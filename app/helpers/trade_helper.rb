#coding: utf-8
require 'cgi'
require 'open-uri'
require 'digest/md5'
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


end
