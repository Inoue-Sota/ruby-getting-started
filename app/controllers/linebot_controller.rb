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
               if event.message["text"] == 'セキュリティ' || event.message["text"] == 'セコムしてますか？'
                message = {
                 type: "text",
                 text: "セコムグループの地方会社で、\r\nセキュリティ事業を主に行っており、\r\nグループ内では珍しいIT系の部門があります。\r\nネットワークインフラからクラウドまで、\r\n色々な仕事を行っています。"
                }
                elsif event.message["text"] == 'ITで世界をHAPPYに' || event.message["text"] == 'モモンガ'
                    message = {
                        type:"text",
                        text:"エスクウェアの島根支社！、\r\n通称「MOMONGA LAB島根(モモンガラボ島根)」。、\r\n社内はゆりかごやバーカウンターがあり、、\r\nこだわりぬかれたレイアウト♪"
                    }
                elsif event.message["text"] == 'ゲーム' || event.message["text"] == 'コンピュータでもっと楽しい毎日を'
                    message = {
                        type:"text",
                        text:"株式会社イプシロンソフトウェア\r\nゲームやスマートフォン等の\r\nソフトウェアを開発しています\u{1008F}！\r\nこだわりのオフィスチェアで\r\n快適にお仕事\u{10090}"
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