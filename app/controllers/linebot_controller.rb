class LinebotController < ApplicationController
  require "line/bot"  # gem "line-bot-api"
 
  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]
 
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
     
  def callback
    body = request.body.read
    
    signature = request.env["HTTP_X_LINE_SIGNATURE"]
    unless client.validate_signature(body, signature)
      error 400 do "Bad Request" end
    end
   
    events = client.parse_events_from(body)
   
    events.each { |event|
    case event
         when Line::Bot::Event::Message
           case event.type
           when Line::Bot::Event::MessageType::Text
               if event.message["text"] == 'セキュリティ' || 'セコムしてますか？'
                message = {
                 type: "text",
                 text: "セコムグループの地方会社で、\r\nセキュリティ事業を主に行っており、\r\nグループ内では珍しいIT系の部門があります。\r\nネットワークインフラからクラウドまで、\r\n色々な仕事を行っています。"
                }
                elsif event.message["text"] == 'bbb'
                    message = {
                        type:"text",
                        text:"bbbです"
                    }
                elsif event.message["text"] == 'ccc'
                    message = {
                        type:"text",
                        text:"cccです"
                    }
                elsif event.message["text"] == 'ddd'
                    message = {
                        type:"text",
                        text:"dddです"
                    }
                elsif event.message["text"] == 'eee'
                    message = {
                        type:"text",
                        text:"eeeです"
                    }
                elsif event.message["text"] == 'fff'
                    message = {
                        type:"text",
                        text:"fffです"
                    }
                else
                    message = {
                        type:"text",
                        text:"知らないキーワードです"
                    }
                end
                
             client.reply_message(event["replyToken"], message)
           when Line::Bot::Event::MessageType::Location
             message = {
               type: "location",
               title: "あなたはここにいますか？",
               address: event.message["address"],
               latitude: event.message["latitude"],
               longitude: event.message["longitude"]
             }
             client.reply_message(event["replyToken"], message)
           end
         end
       }
   
       head :ok
     end
 end