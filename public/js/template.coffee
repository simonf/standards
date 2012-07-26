root = exports ? this

root.Template = {
  tagcloudelement : "<a class='taginlist' href='' onclick='javascript:View.tagClicked(\"<%= tag %>\"); return false;'><%= tag %></a>",
  linkinlist : "<div class='standard'><a href='' class='edit-link' data-id='<%= std._id %>'><%= std.name %></a></div>",
  currentlist: """
    <div class='standard-row'> 
      <div class='list-name'><%= View.getDefaultAttribute(std,"name","Unknown") %></div>
      <div class='sh-lifecycle'><a data_id='<%= std._id %>' href=''>&gt;&gt;</a></div>
      <div class="std-wrap">
        <div class='list-current std-lifecycle-item'>
          <div class="view-label">Current: </div>
          <div class="li-content"><%= View.getDefaultAttribute(std,"current","") %></div>
        </div>
        <div class='list-lifecycle' id='life_<%= std._id %>'>
          <div class='list-emerging std-lifecycle-item'>
            <div class='view-label'>Emerging: </div>
	    <div class="li-content"><%= View.getDefaultAttribute(std,"emerging","") %></div>
	  </div>
	  <div class='list-deprecated std-lifecycle-item'>
	    <div class='view-label'>Deprecated: </div>
	    <div class="li-content"><%= View.getDefaultAttribute(std,"deprecated","") %></div>
	  </div>
	  <div class='list-obsolete std-lifecycle-item'>
	    <div class='view-label'>Obsolete: </div>
	    <div class="li-content"><%= View.getDefaultAttribute(std,"obsolete","") %></div>
	  </div>
	  <div class='list-notes std-lifecycle-item'>
	    <div class='view-label'>Notes: </div>
	    <div class="li-content"><%= View.getDefaultAttribute(std,"notes","") %></div>
	  </div>
	  <div class='list-meta std-lifecycle-item'>
	    <div class='view-label'>Owner: </div>
	    <div class="list-owner"><%= View.getDefaultAttribute(std,"owner","") %></div>
	    <div class='view-label'>Last edited: </div>
	    <div class="list-updated"><% if(_.isString(std.updated)) { %>
	    	 <%= std.updated.split("T")[0] %>
		 <% } %>
	    </div>
	  </div>
	</div>
      </div>
      <div class='list-tags'>Tags: <%= View.getDefaultAttribute(std,"tags","") %></div>
      <div class='list-item-links'>
        <a href='' class='edit-link' data-id='<%= std._id %>'>edit</a>
        <a href='' class='del-link' data-id='<%= std._id %>'>delete</a>
      </div>
    </div>
""",
  stdform: """
      <div id='form'>
	<form id='stdform' method='post' action=''>
	  <input type='hidden' id='_id' value='<%= std._id %>'/>
	  <div id='name-wrap'>
	    <label for='name'>Name</label>
	    <input id='name' type='text' value='<%=std.name %>'/>
	  </div>
 	  <div id='owner-updated-wrap'>
            <div id='owner-wrap'>
              <label for='owner' id='owner-label'>Owner</label>
              <input id='owner' type='text' value='<%= std.owner %>'/>
	    </div>
	    <div id='updated-wrap'>
	      <label for='updated' id='updated-label'>Updated</label>
              <span id='updated'><% if(_.isString(std.updated)) { %>
               <%= std.updated.split("T")[0] %>
               <% } %>
              </span>
	    </div>
	  </div>
          <div id='current-wrap'>
	    <label for='current'>Current</label>
	    <textarea class='std-textarea' rows='5'><%= std.current %></textarea>
	  </div>
	  <div id='emerging-wrap'>
	    <label for='emerging'>Emerging</label>
	    <textarea class='std-textarea' rows='5'><%= std.emerging %></textarea>
	  </div>
	  <div id='deprecated-wrap'>
	    <label for='deprecated'>Deprecated</label>
	    <textarea class-'std-textarea' rows='5'><%= std.deprecated %></textarea>
	  </div>
	  <div id='obsolete-wrap'>
	    <label for='obsolete'>Obsolete</label>
	    <textarea class-'std-textarea' rows='5'><%= std.obsolete %></textarea>
	  </div>
          <div id='notes-wrap'>
            <label for='notes'>Notes</label>
            <textarea class-'std-textarea' rows='5'><%= std.notes %></textarea>
          </div>
	  <div id='tags-wrap'>
	    <label for='tags'>Tags (comma separated)</label>
	    <input id='tags' type='text' value='<%= std.tags.join(' ') %>'/>
	  </div>
          <div id='edit-buttons-wrap'>
	    <input type='submit' value='Submit' id='submit'></input>
	  </div>
          <div id='cancel-wrap'>
	    <a href='' id='cancel-button'>Cancel</a>
          </div>
	</form>
      </div>
""",
  commentform : """
    <div id="comment-form">
      <form action="/comment/<%= std._id %>" method="post">
      </form>
    </div>
"""
}