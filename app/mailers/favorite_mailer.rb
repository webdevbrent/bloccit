class FavoriteMailer < ApplicationMailer
  default from: 'webdeveloperbrent@gmail.com'

  def new_comment(user, post, comment)

    # we set three different headers to enable conversation threading in different email clients.
    headers["Message-ID"] = "<comments/#{comment.id}@your-app-name.example>"
    headers["In-Reply-To"] = "<post/#{post.id}@your-app-name.example>"
    headers["References"] = "<post/#{post.id}@your-app-name.example>"

    @user = user
    @post = post
    @comment = comment

    # the mail method takes a hash of mail-relevant information - the subject the to address, 
    # the from (we're using the default), and any cc or bcc information - and prepares the email to be sent.
    mail(to: user.email, subject: "New comment on #{post.title}")
  end

  def new_post(post)

    # we set three different headers to enable conversation threading in different email clients.
    headers["Message-ID"] = "<posts/#{post.id}@your-app-name.example>"
    headers["In-Reply-To"] = "<post/#{post.id}@your-app-name.example>"
    headers["References"] = "<post/#{post.id}@your-app-name.example>"

    @post = post

    # the mail method takes a hash of mail-relevant information - the subject the to address, 
    # the from (we're using the default), and any cc or bcc information - and prepares the email to be sent.
    mail(to: post.user.email, subject: "You're following, #{post.title}!")
  end

end
