root = exports ? this

root.Template = {
  tagcloudelement : "<a class='taginlist' href='' onclick='javascript:View.tagClicked(\"<%= tag %>\"); return false;'><%= tag %></a>",
  linkinlist : "<div class='standard'><a href='' class='edit-link' data-id='<%= std._id %>'><%= std.name %></a></div>",
  currentlist: """
    <div class='standard-row'> 
      <div class='list-name'><%= View.getDefaultAttribute(std,"name","Unknown") %></div>
      <div class='list-current'>
        <span class="view-label">Current: </span>
        <%= View.getDefaultAttribute(std,"current","") %>
        <span class='sh-lifecycle'><a data_id='<%= std._id %>' href=''>more</a></span>
      </div>
      <div class='list-lifecycle' id='life_<%= std._id %>'>
       <div class='list-emerging'>
        <span class='view-label'>Emerging: </span>
	<%= View.getDefaultAttribute(std,"emerging","") %>
       </div>
       <div class='list-deprecated'>
        <span class='view-label'>Deprecated: </span>
	<%= View.getDefaultAttribute(std,"deprecated","") %>
       </div>
       <div class='list-obsolete'>
        <span class='view-label'>Obsolete: </span>
	<%= View.getDefaultAttribute(std,"obsolete","") %>
       </div>
       <div class='list-notes'>
        <span class='view-label'>Notes: </span>
	<%= View.getDefaultAttribute(std,"notes","") %>
       </div>
       <div class='list-meta'>
        <span class='view-label'>Owner: </span>
        <span class="list-owner"><%= View.getDefaultAttribute(std,"owner","") %></span>
        <span class='view-label'>Last edited: </span>
        <span class="list-updated"><% if(_.isString(std.updated)) { %>
               <%= std.updated.split("T")[0] %>
               <% } %></span>
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
          <div id='owner-wrap'>
            <label for='owner' id='owner-label'>Owner</label>
            <input id='owner' type='text' value='<%= std.owner %>'/>
            <span id='updated-timestamp'>Updated: <% if(_.isString(std.updated)) { %>
               <%= std.updated.split("T")[0] %>
               <% } %>
            </span>
	  </div>
          <div id='current-wrap'>
	    <label for='current'>Current</label>
	    <textarea id='current' rows='3'><%= std.current %></textarea>
	  </div>
	  <div id='emerging-wrap'>
	    <label for='emerging'>Emerging</label>
	    <textarea id='emerging' rows='3'><%= std.emerging %></textarea>
	  </div>
	  <div id='deprecated-wrap'>
	    <label for='deprecated'>Deprecated</label>
	    <textarea id='deprecated' rows='3'><%= std.deprecated %></textarea>
	  </div>
	  <div id='obsolete-wrap'>
	    <label for='obsolete'>Obsolete</label>
	    <textarea id='obsolete' rows='3'><%= std.obsolete %></textarea>
	  </div>
          <div id='notes-wrap'>
            <label for='notes'>Notes</label>
            <textarea id='notes' rows='3'><%= std.notes %></textarea>
          </div>
	  <div id='tags-wrap'>
	    <label for='tags'>Tags (comma separated)</label>
	    <input id='tags' type='text' value='<%= std.tags %>'/>
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