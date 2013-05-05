require "rubygems"
require 'sinatra'
require "mongo_mapper"
require 'em-websocket'
require 'yajl'
require 'haml'
require 'sinatra/base'
require 'thin'

class Post
  include MongoMapper::Document
  
  key :content,    String
  timestamps!
  
  attr_accessible :content
end

configure do
  MongoMapper.database = 'posts'
end

@channel = EM::Channel.new

EventMachine.run do
  class App < Sinatra::Base

      get '/' do
      	@post = Post.new
      	@post.save!
      	redirect @post.id
      	erb :index
      end

      post '/:id' do
        @channel.push "#{params[:content]}"
      end
      
      get '/:id' do
	    	@post = Post.find_by__id(params[:id])
	    	
	    	erb :index
	    end
  end
  
  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
      ws.onopen {
        sid = @channel.subscribe { |content| ws.send content }

        ws.onmessage { |content|
          @channel.push "#{content}"
        }

        ws.onclose {
          @channel.unsubscribe(sid)
        }
      }

  end

  App.run!({:port => 3000})
end