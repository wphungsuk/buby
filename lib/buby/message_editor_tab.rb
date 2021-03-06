class Buby
  # Extensions that register an +IMessageEditorTabFactory+ must return instances
  # of this interface, which Burp will use to create custom tabs within its HTTP
  # message editors.
  #
  # @abstract
  # @todo voodoo method wrapping
  class MessageEditorTab
    include Java::Burp::IMessageEditorTab
    include Java::Burp::IMessageEditorTabFactory
    
    attr_accessor :controller, :editable
    # (see Buby::MessageEditorTabFactory#createNewInstance)
    def initialize controller, editable
      @controller = controller
      @editable = editable
    end

    # (see Buby::MessageEditorTabFactory#createNewInstance)
    def self.createNewInstance controller, editable
      self.new controller, editable
    end

    # This method returns the caption that should appear on the custom tab
    # when it is displayed.
    # @note Burp invokes this method once when the tab is first generated, and
    #   the same caption will be used every time the tab is displayed.
    #
    # @return [String] The caption that should appear on the custom tab when
    #   it is displayed.
    #
    def getTabCaption; self.class.name; end

    # This method returns the component that should be used as the contents of
    # the custom tab when it is displayed.
    # @note Burp invokes this method once when the tab is first generated, and
    #   the same component will be used every time the tab is displayed.
    #
    # @return The component that should be used as the contents of the custom
    #   tab when it is displayed.
    #
    def getUiComponent; raise NotImplementedError; end

    # The hosting editor will invoke this method before it displays a new HTTP
    # message, so that the custom tab can indicate whether it should be
    # enabled for that message.
    #
    # @param [Array<byte>] content The message that is about to be displayed.
    # @param [Boolean] isRequest Indicates whether the message is a request or
    #   a response.
    # @return [Boolean] The method should return +true+ if the custom tab is
    #   able to handle the specified message, and so will be displayed within
    #   the editor. Otherwise, the tab will be hidden while this message is
    #   displayed.
    #
    def isEnabled(content, isRequest)
      content = String.from_java_bytes content
      raise NotImplementedError
    end

    # The hosting editor will invoke this method to display a new message or
    # to clear the existing message. This method will only be called with a
    # new message if the tab has already returned +true+ to a call to
    # {#isEnabled} with the same message details.
    #
    # @param [Array<byte>] content The message that is to be displayed, or
    #   +nil+ if the tab should clear its contents and disable any editable
    #   controls.
    # @param [Boolean] isRequest Indicates whether the message is a request or
    #   a response.
    #
    def setMessage(content, isRequest); raise NotImplementedError; end

    # This method returns the currently displayed message.
    #
    # @return [Array<byte>] The currently displayed message.
    #
    def getMessage; raise NotImplementedError; end

    # This method is used to determine whether the currently displayed message
    # has been modified by the user. The hosting editor will always call
    # {#getMessage} before calling this method, so any pending edits should be
    # completed within {#getMessage}.
    #
    # @return [Boolean] The method should return +true+ if the user has
    #   modified the current message since it was first displayed.
    #
    def isModified; raise NotImplementedError; end

    # This method is used to retrieve the data that is currently selected by
    # the user.
    #
    # @return [Array<byte>] The data that is currently selected by the user.
    #   This may be +nil+ if no selection is currently made.
    #
    def getSelectedData; raise NotImplementedError; end
  end
end