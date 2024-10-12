
class Api::V1::FactsController < ApplicationController
    include AuthenticationCheck
      
    before_action :is_user_logged_in
    before_action :set_fact, only: [:show, :update, :destroy]
    before_action :check_access, only: [:index, :create]
      
    # GET /members/:member_id/facts
    def index
        @member = Member.find_by(id: params[:member_id], user_id: current_user.id)
        if @member
            render json: @member.facts, status: 200
        else
            render json: { error: "Member not found" }, status: 404
        end
    end
      
    # GET /members/:member_id/facts/:id
    def show
        if @fact
            render json: @fact, status: 200
        else
            render json: { error: "Fact not found" }, status: 404
        end
    end
      
    # POST /members/:member_id/facts
    def create
        @member = Member.find_by(id: params[:member_id], user_id: current_user.id)
        if @member
            @fact = @member.facts.new(fact_params)
            if @fact.save
                render json: @fact, status: 201
            else
                render json: { error: "Unable to create fact: #{@fact.errors.full_messages.to_sentence}" }, status: 400
            end
        else
            render json: { error: "Member not found" }, status: 404
        end
    end
      
    # PUT /members/:member_id/facts/:id
    def update
        if @fact.update(fact_params)
            render json: @fact, status: 200
        else
            render json: { error: "Unable to update fact: #{@fact.errors.full_messages.to_sentence}" }, status: 400
        end
    end
      
    # DELETE /members/:member_id/facts/:id
    def destroy
        @fact.destroy
        render json: { message: 'Fact record successfully deleted.' }, status: 200
    end
      
    private
      
    def fact_params
        params.require(:fact).permit(:fact_text, :likes)
    end
      
    def set_fact
         @fact = Fact.find_by(id: params[:id], member_id: params[:member_id])
    end
        
    def check_access 
        @member = Member.find_by(id: params[:member_id], user_id: current_user.id)
        if @member.nil?
            render json: { message: "The current user is not authorized for that data." }, status: :unauthorized
        end
    end
end
