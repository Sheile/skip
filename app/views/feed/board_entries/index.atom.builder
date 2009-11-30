atom_feed do |feed|
  feed.title("#{@title_name} » Example Feed")
  feed.updated(@entries.first.created_on)

  @entries.each do |m|
    feed.entry(m, :url => entry_link_to(m)) do |entry|
      entry.title(m.title)
#      entry.content(trans(m), :type => "html")
#      entry.author do |a|
#        a.name(entry.user.name)
#      end
    end
  end
end
