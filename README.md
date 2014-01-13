# 支付宝手机支付

WAP支付

**构造数据请求，获取token**
    
    先构造req_data，写成xml格式
    生成sign签名，签名前先字典排序，加密时把secret_key放在最后
    发送HTTP请求
    解析获得的数据，从中得到request_token

```Ruby
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
```

```Ruby
#产生签名sign
	def generate_wap_sign(options)
		query = options.sort.map do |key, value|
			"#{key}=#{value}"
		end.join('&')
		
		Digest::MD5.hexdigest("#{query}#{@secret_key}")
	end
```

  
**调用手机WAP支付接口**

    这里要把service参数修改一下
    然后再次构造req_data，只不过这里的数据为上面获取的token
    然后是生成sign
    发送HTTP请求发起交易

**回调函数**

    一个是GET同步处理
    另一个是POST服务器异步处理
    参数中包含 trade_no