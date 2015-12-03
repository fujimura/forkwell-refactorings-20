require 'erb'
require 'ostruct'
require 'test/unit'
require 'action_view'

class User
  def initialize(role = :admin)
    @role = role
  end

  def admin?
    @role == :admin
  end
end

module ViewHelper
  include ActionView::Helpers::TagHelper
  def message_by_user_role user, message
    src = if user.admin?
            "/assets/message/admin.png"
          else
            "/assets/message/general.png"
          end

    content_tag :div, tag(:img, src: src) + content_tag(:span, message.body)
  end
end

ERB_TEMPLATE = DATA.read

class MyTest < Test::Unit::TestCase
  include ViewHelper

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
<%= message_by_user_role(current_user, @message) %>
