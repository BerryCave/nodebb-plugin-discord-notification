<form role="form" class="discord-notification-settings">

	<ul class="nav nav-pills">
		<li>
			<a href="#configuration2" data-toggle="tab">
                        	Forum
                	</a>
		</li>
		<li>
			<a href="#configuration1" data-toggle="tab">
                        	Programmazione
                	</a>
		</li>
		<li>
			<a href="#configuration3" data-toggle="tab">
                        	Single Board
                	</a>
		</li>
		<li>
			<a href="#configuration4" data-toggle="tab">
                        	Astronomia
                	</a>
		</li>
		<li>
			<a href="#configuration5" data-toggle="tab">
                        	IoT
                	</a>
		</li>
		<li>
			<a href="#configuration6" data-toggle="tab">
                        	Blog
                	</a>
		</li>
	</ul>

	<div class="row">
		<div class="col-sm-2 col-xs-12 settings-header">[[discord-notification:webhook]] 1</div>		
		<div class="col-sm-10 col-xs-12">
			<div class="tab-content">
				<div class="tab-pane fade" id="configuration1">
					<ul class="configuration1">
						<div class="form-group">
							<label for="webhookURL1">[[discord-notification:webhook-url]]</label>
							<input type="text" class="form-control" id="webhookURL1" name="webhookURL1" />
							<p class="help-block">[[discord-notification:webhook-help]]</p>
						</div>
						<div class="form-group">
							<label for="postCategories1">[[discord-notification:post-categories]]</label>
							<select class="form-control" id="postCategories1" name="postCategories1" size="10" multiple></select>
						</div>						
					</ul>
				</div>
				
				<div class="tab-pane fade" id="configuration2">
					<ul class="configuration2">
						<div class="form-group">
							<label for="webhookURL2">[[discord-notification:webhook-url]]</label>
							<input type="text" class="form-control" id="webhookURL2" name="webhookURL2" />
							<p class="help-block">[[discord-notification:webhook-help]]</p>
						</div>
						<div class="form-group">
							<label for="postCategories2">[[discord-notification:post-categories]]</label>
							<select class="form-control" id="postCategories2" name="postCategories2" size="10" multiple></select>
						</div>						
					</ul>
				</div>
				
				<div class="tab-pane fade" id="configuration3">
					<ul class="configuration3">
						<div class="form-group">
							<label for="webhookURL3">[[discord-notification:webhook-url]]</label>
							<input type="text" class="form-control" id="webhookURL3" name="webhookURL3" />
							<p class="help-block">[[discord-notification:webhook-help]]</p>
						</div>
						<div class="form-group">
							<label for="postCategories3">[[discord-notification:post-categories]]</label>
							<select class="form-control" id="postCategories3" name="postCategories3" size="10" multiple></select>
						</div>						
					</ul>
				</div>
				
				<div class="tab-pane fade" id="configuration4">
					<ul class="configuration4">
						<div class="form-group">
							<label for="webhookURL4">[[discord-notification:webhook-url]]</label>
							<input type="text" class="form-control" id="webhookURL4" name="webhookURL4" />
							<p class="help-block">[[discord-notification:webhook-help]]</p>
						</div>
						<div class="form-group">
							<label for="postCategories4">[[discord-notification:post-categories]]</label>
							<select class="form-control" id="postCategories4" name="postCategories4" size="10" multiple></select>
						</div>						
					</ul>
				</div>
				
				<div class="tab-pane fade" id="configuration5">
					<ul class="configuration5">
						<div class="form-group">
							<label for="webhookURL5">[[discord-notification:webhook-url]]</label>
							<input type="text" class="form-control" id="webhookURL5" name="webhookURL5" />
							<p class="help-block">[[discord-notification:webhook-help]]</p>
						</div>
						<div class="form-group">
							<label for="postCategories5">[[discord-notification:post-categories]]</label>
							<select class="form-control" id="postCategories5" name="postCategories5" size="10" multiple></select>
						</div>						
					</ul>
				</div>
				
				<div class="tab-pane fade" id="configuration6">
					<ul class="configuration6">
						<div class="form-group">
							<label for="webhookURL6">[[discord-notification:webhook-url]]</label>
							<input type="text" class="form-control" id="webhookURL6" name="webhookURL6" />
							<p class="help-block">[[discord-notification:webhook-help]]</p>
						</div>
						<div class="form-group">
							<label for="postCategories6">[[discord-notification:post-categories]]</label>
							<select class="form-control" id="postCategories6" name="postCategories6" size="10" multiple></select>
						</div>						
					</ul>
				</div>
			</div>
									
		</div>		
	</div>

	<div class="row">
		<div class="col-sm-2 col-xs-12 settings-header">[[discord-notification:notification]]</div>
		<div class="col-sm-10 col-xs-12">
			<div class="form-group">
				<label for="maxLength">[[discord-notification:notification-max-length]]</label>
				<input type="number" class="form-control" id="maxLength" name="maxLength" min="1" max="1024" value="100" />
				<p class="help-block">[[discord-notification:notification-max-length-help]]</p>
			</div>			
			<div class="checkbox">
				<label for="topicsOnly" class="mdl-switch mdl-js-switch mdl-js-ripple-effect">
					<input type="checkbox" class="mdl-switch__input" id="topicsOnly" name="topicsOnly" />
					<span class="mdl-switch__label">[[discord-notification:topics-only]]</span>
				</label>
			</div>
			<div class="form-group">
				<label for="messageContent">[[discord-notification:message]] <small>([[discord-notification:message-sidenote]])</small></label>
				<textarea class="form-control" id="messageContent" name="messageContent" maxlength="512"></textarea>
				<p class="help-block">[[discord-notification:message-help]]</p>
			</div>
		</div>
	</div>
</form>

<button id="save" class="floating-button mdl-button mdl-js-button mdl-button--fab mdl-js-ripple-effect mdl-button--colored">
	<i class="material-icons">save</i>
</button>

<script>
	$(document).ready(function() {
		socket.emit('categories.get', function(err, data) {
			categories = data;
			for (var i = 0; i < categories.length; ++i) {
				$('[id^=postCategories]').append('<option value=' + categories[i].cid + '>' + categories[i].name + '</option>');
			}
		});
	});

	require(['settings'], function(Settings) {
		Settings.load('discord-notification', $('.discord-notification-settings'));

		$('#save').on('click', function() {
			Settings.save('discord-notification', $('.discord-notification-settings'), function() {
				app.alert({
					type: 'success',
					alert_id: 'discord-notification-saved',
					title: 'Settings Saved',
					message: 'Please reload your NodeBB to apply these settings',
					clickfn: function() {
						socket.emit('admin.reload');
					}
				});
			});
		});
	});
</script>
