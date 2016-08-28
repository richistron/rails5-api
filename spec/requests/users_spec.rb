require 'rails_helper'

RSpec.describe 'Users', type: :request do

  def create_new_user(custom = nil)
    user = custom || { email: 'richistron@gmail.com', password: '123' }
    post '/users', :params => { :user => user }
  end

  describe 'GET /users' do
    it 'Loads list of users' do
      get '/users'
      json = JSON.parse(response.body)
      expect(json.count).to eq(0)
    end
  end


  describe 'POST /users' do

    it 'Creates a new user' do
      create_new_user
      expect(response).to have_http_status(201)
      expect(response.content_type).to eq('application/json')
    end

    it 'Does not creates duplicated user' do
      create_new_user
      expect(response).to have_http_status(201)
      create_new_user
      expect(response).to have_http_status(422)
      expect(response.content_type).to eq('application/json')
    end

    it 'Incorrect parameters' do
      create_new_user({ name: 'pancho' })
      expect(response).to have_http_status(422)
      create_new_user({ email: 'richistron@gmail.com' })
      expect(response).to have_http_status(422)
      create_new_user({ password: 'richistron@gmail.com' })
      expect(response).to have_http_status(422)
      create_new_user()
      expect(response).to have_http_status(201)
    end
  end

  describe 'GET /users/:id' do

    it 'User not found' do
      get '/users/1'
      expect(response).to have_http_status(404)
    end

    it 'User found' do
      create_new_user
      get '/users/1'
      expect(response).to have_http_status(200)
    end

  end

  describe 'PUT /users/:id' do
    it 'updates email' do
      create_new_user
      expect(response).to have_http_status(201)
      user = {
        email: 'example@example.com'
      }
      put '/users/1', :params => { :user => user }
      get '/users/1'
      json = JSON.parse(response.body)
      expect(json['id']).to eq(1)
      expect(json['email']).to eq('example@example.com')
    end
  end

  describe 'DELETE /users/:id' do
    it 'deletes user' do
      create_new_user
      delete '/users/1'
      expect(response).to have_http_status(204)
      get '/users/1'
      expect(response).to have_http_status(404)
    end
  end
end
