

def is_mac?
  RUBY_PLATFORM.downcase.include?("darwin")
end

def open_in_browser(list)
  if is_mac?
    open_in_safari(list)
  end
end


def open_in_safari(list)
osa = <<END
set _url_list to {#{list.flatten.map { |u| "\"#{u}\""}.join(", ")}}

tell application "Safari"
	make new document
	set _w to window 1
	tell _w
		repeat with _url in _url_list		
			set URL of (make new tab) to _url
		end repeat
	end
	tell _w to close tab 1
end tell
END

`osascript -e '#{osa}'`
end
