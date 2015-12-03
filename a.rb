require 'erb'
require 'ostruct'
require 'test/unit'

class User
  def initialize(role = :admin)
    @role = role
  end

  def admin?
    @role == :admin
  end

  def message_for_admin message
    img_tag = '<img src="/assets/message/admin.png" />'
    span_tag = "<span>#{message.body}</span>"
    "<div>#{img_tag}#{span_tag}</div>"
  end

  def message_for_general message
    img_tag = '<img src="/assets/message/general.png" />'
    span_tag = "<span>#{message.body}</span>"
    "<div>#{img_tag}#{span_tag}</div>"
  end
end

ERB_TEMPLATE = DATA.read

class MyTest < Test::Unit::TestCase
  def test_admin
    current_user = User.new :admin
    @message = OpenStruct.new(body: "This is admin")

    actual = ERB.new(ERB_TEMPLATE).result(binding).strip
    expected = %(<div><img src="/assets/message/admin.png" /><span>This is admin</span></div>)

    assert_equal(actual, expected)
  end

  def test_general
    current_user = User.new :general
    @message = OpenStruct.new(body: "This is general")

    actual = ERB.new(ERB_TEMPLATE).result(binding).strip
    expected = %(<div><img src="/assets/message/general.png" /><span>This is general</span></div>)

    assert_equal(actual, expected)
  end
end

__END__
<% if current_user.admin? %>
  <%= current_user.message_for_admin(@message) %>
<% else %>
  <%= current_user.message_for_general(@message) %>
<% end %>
