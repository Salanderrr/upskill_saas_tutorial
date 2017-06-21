class ContactsController < ApplicationController
  
  #GET request to /contact-us
  #show new contact form
  def new
    @contact = Contact.new
  end
  
  #POST request to /contacts
  def create
    #Mass assignment of form fields to Contact object
    @contact = Contact.new(contact_params)
    # save the contact object to the database
    if @contact.save
      # Store form fields via parameeters, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:body]
      #plug variables into Contact Mailer
      #email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      #store success messages in flash hash
      #and redirect to the new action
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      #if contact object doesnt save, 
      #store errors in flash hash, and redirect to the new action 
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  
  private
  #to collect data from form , we need to use strong parameters
  #and whitelist the form fields. security feature
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end