#coding: utf-8
require 'net/http'
require 'cgi'
# require Rails.root.to_s + '/lib/alipay'
class TradeController < ApplicationController

	# include TradeHelper
	require Rails.root.to_s + '/lib/alipay'

	before_filter :process_trade, :only => [:callback, :notify]

	def process_trade
		@out_trade_no = params[:out_trade_no]
		@trade_no = params[:trade_no]
		p '交易号码为:' + @trade_no.to_s
	end

	def callback
		flash[:notice] = "付款成功" + @trade_no.to_s
		redirect_to :root
	end

	def notify
		render text: 'success'
	end

	def get_auth_token
		options = {
			:service		=> 'alipay.wap.trade.create.direct',
			:format 		=> 'xml',
			:v					=> '2.0',
			:partner		=> '2088211538272854',
			:req_id			=> '1282889689836',
			:sec_id			=> 'MD5',
			:key				=> 'rf42g23jash5adgf3gwov25e3v5s54jx'
		}
		req = {
			:subject 				=> 'feiding',
			:out_trade_no		=> Time.now.to_s,
			:total_fee					=> '0.01',
			:seller_account_name	=> 'admin@feding.net',
			:call_back_url				=> 'http://192.168.1.201:3000/trade/callback',
			:notify_url						=> 'http://192.168.1.201:3000/trade/notify',
			:out_user				=> '1234',
			:merchant_url		=> 'http://192.168.1.201:3000',
			:pay_expire			=> '30'
		}
		url =  Alipay.wap_trade_auth_url(options, req)
		token = Alipay.get_token(url)

		options[:service] = 'alipay.wap.auth.authAndExecute'
		url2 = Alipay.get_trade_url(options, token)

		redirect_to url2
		
	end


end
