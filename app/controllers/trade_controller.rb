#coding: utf-8
require 'net/http'
require 'cgi'
class TradeController < ApplicationController

	include TradeHelper

	def process_trade

	end

	def done

	end

	def notify

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
			:out_trade_no		=> '123456789',
			:total_fee					=> '0.01',
			:seller_account_name	=> 'admin@feding.net',
			:call_back_url				=> 'http://127.0.0.1:3000/callback',
			:notify_url						=> 'http://127.0.0.1:3000/notify',
			:out_user				=> '1234',
			:merchant_url		=> 'http://127.0.0.1:3000',
			:pay_expire			=> '30'
		}
		url =  wap_trade_auth_url(options, req)
		token = get_token(url)

		options[:service] = 'alipay.wap.auth.authAndExecute'
		url2 = get_trade_url(options, token)

		redirect_to url2
		
	end

	def create_trade

	end


end
