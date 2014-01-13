#coding: utf-8
require 'cgi'
require 'open-uri'
require 'digest/md5'
require 'nokogiri'
module TradeHelper

	GATEWAY_URL = 'http://wappaygw.alipay.com/service/rest.htm'

	def wap_trade_auth_url(options, req_options)
		req_data = create_req_data(req_options)
		options =  options.merge(:req_data => req_data)
		@secret_key = options[:key]
		@parnter = options['parnter']
		options.delete(:key)

		"#{GATEWAY_URL}?#{query_string(options)}"
	end


	def create_req_data(options)
		req_data = '<direct_trade_create_req>'
		options.each do |key, value|
			req_data += "<#{key}>" + value + "</#{key}>"
		end
		req_data += '</direct_trade_create_req>'

		return req_data
	end

	def query_string(options)
		sign = generate_wap_sign(options)
		options = options.merge(:sign => sign)

		options.map do |key, value|
			"#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
		end.join('&')
	end


	#产生签名sign
	def generate_wap_sign(options)
		query = options.sort.map do |key, value|
			"#{key}=#{value}"
		end.join('&')
		
		Digest::MD5.hexdigest("#{query}#{@secret_key}")
	end


	def get_token(url)
		uri = URI(url)
		ret = Net::HTTP.get(uri)

		ret = ret.split('&')
		ret_options = {}

		ret.each do |tmp|
			tmp = tmp.split('=')
			key = tmp[0]
			value = tmp[1]
			ret_options[key] = value
		end

		res_data = ret_options['res_data']
		sign = ret_options['sign']
		request_token = ''
		if sign
			res_data = CGI.unescape(res_data)
			doc = Nokogiri::XML(res_data)
			request_token =  doc.xpath('//direct_trade_create_res/request_token').text
		end
		return request_token
	end

	def get_trade_url(options, token)
		req_data = create_req_data_2(token)
		options =  options.merge(:req_data => req_data)
		@secret_key = options[:key]
		p @secret_key + '-------------------'
		options.delete(:key)

		"#{GATEWAY_URL}?#{query_string(options)}"

	end

	def create_req_data_2(token)
		req_data = '<auth_and_execute_req><request_token>'
		req_data += token.to_s
		req_data += '</request_token></auth_and_execute_req>'
		return req_data
	end




end
