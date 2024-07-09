class ApplicationController < ActionController::API

    include ExceptionHandler

    def options
        head :ok
    end
end
