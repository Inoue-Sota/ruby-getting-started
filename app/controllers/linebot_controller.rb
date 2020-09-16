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
                   message = [
                        {
                         type: "image",
                         originalContentUrl: "https://gentle-anchorage-97083.herokuapp.com/secom1.jpg",
                         previewImageUrl: "https://gentle-anchorage-97083.herokuapp.com/secom1.jpg"
        		          },
        		        {
                         type: "text",
                         text: "〈セコム山陰株式会社〉\r\nセコムグループの地方会社で、\r\nセキュリティ事業を主に行っており、\r\nグループ内では珍しいIT系の部門があります。\u{10008F}\r\nネットワークインフラからクラウドまで、\r\n色々な仕事を行っています。\u{10002D}\r\nhttps://www.secom-sanin.co.jp/"
                        }
    		        ]
                elsif event.message["text"] == 'ITで世界をHAPPYに' || event.message["text"] == 'モモンガ'
                    message = [
                        {
                         type: "image",
                         originalContentUrl: "https://gentle-anchorage-97083.herokuapp.com/ekusuwea1.jpg",
                         previewImageUrl: "https://gentle-anchorage-97083.herokuapp.com/ekusuwea1.jpg"
        		          },
        		        {
                         type: "text",
                         text: "〈株式会社エクスウェア〉\r\nエクスウェアの島根支社\u{100079}\r\n通称「MOMONGA LAB島根(モモンガラボ島根)」。\r\n社内はゆりかごやバーカウンターがあり、\r\nこだわりぬかれたレイアウト\u{100039}"
                        },
        		        {
                         type: "text",
                         text: "https://www.xware.co.jp/"
                        }

    		        ]
    		       elsif event.message["text"] == 'ゲーム' || event.message["text"] == 'コンピュータでもっと楽しい毎日を'
                    message = [
                        {
                         type: "image",
                         originalContentUrl: "https://gentle-anchorage-97083.herokuapp.com/ipushiron1.jpg",
                         previewImageUrl: "https://gentle-anchorage-97083.herokuapp.com/ipushiron1.jpg"
        		          },
        		        {
                         type: "text",
                         text: "〈株式会社イプシロンソフトウェア〉\r\nゲームやスマートフォン等の\r\nソフトウェアを開発しています！\u{10006E}\r\nマッサージチェアで\r\nゆっくりリラックスも\u{100090}\r\nhttp://www.epsilon-software.co.jp/"
                        }
    		        ]
                elsif event.message["text"] == 'ファミコン' || event.message["text"] == '男女比'
                    message = [
                        {
                         type: "image",
                         originalContentUrl: "https://gentle-anchorage-97083.herokuapp.com/yakumo2.jpg",
                         previewImageUrl: "https://gentle-anchorage-97083.herokuapp.com/yakumo2.jpg"
        		          },
        		        {
                         type: "text",
                         text: "〈株式会社八雲ソフトウェア〉\r\n女性社員が3割も！女性率が高い企業\u{100068}\r\n駅チカなので松江駅から走って１分！\r\nオフィスにはファミコンも…！？\u{100085}\r\nhttps://8clouds.co.jp/"
                        }
    		        ]
                elsif event.message["text"] == '校舎' || event.message["text"] == '濱記'
                    message = [
                        {
                         type: "image",
                         originalContentUrl: "https://gentle-anchorage-97083.herokuapp.com/e-front2.jpg",
                         previewImageUrl: "https://gentle-anchorage-97083.herokuapp.com/e-front2.jpg"
        		          },
        		        {
                         type: "text",
                         text: "〈株式会社e-Front 島根支店〉\r\n廃校した校舎がオフィスに変身\u{10007B}\r\n自然に囲まれた空間で\r\n牧歌的な雰囲気で\r\nゆるりと仕事をしてみませんか。\u{10005C}"
                        },
        		        {
                         type: "text",
                         text: "http://shimane.e-front.co.jp/"
                        }

    		        ]
                elsif event.message["text"] == '社会の問題点を解決する' || event.message["text"] == '人材育成' || event.message["text"] == 'エンジニアの思いに寄り添う'
                    message = [
                        {
                         type: "image",
                         originalContentUrl: "https://gentle-anchorage-97083.herokuapp.com/pasona1.jpg",
                         previewImageUrl: "https://gentle-anchorage-97083.herokuapp.com/pasona1.jpg"
        		          },
        		        {
                         type: "text",
                         text: "〈株式会社パソナテック 島根Lab〉\r\n【東証一部パソナグループ】\r\n全国の拠点と連携しWeb系システムの\r\nニアショア開発をおこなっています。\u{10007F}\r\nこだわりのオフィスチェアで快適にお仕事\u{100033}"
                        },
        		        {
                         type: "text",
                         text: "https://www.pasonatech.co.jp/"
                        }

    		        ]
                else
                    message = {
                        type:"text",
                        text:"キーワード\r\n・セコムしてますか？\r\n・ゲーム\r\n・モモンガ\r\n・人材育成\r\n・ファミコン\r\n・校舎\r\n気になるキーワードを\r\nコメントしてみてね\u{100096}"
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