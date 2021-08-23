(function(module) {
	'use strict';

	var User = require.main.require('./src/user');
	var Topics = require.main.require('./src/topics');
	var Categories = require.main.require('./src/categories');
	var translator = require.main.require('./public/src/modules/translator');
	var meta = require.main.require('./src/meta');
	var nconf = require.main.require('nconf');
	var async = require.main.require('async');

	var Discord = require('discord.js');

	var hooks = {};
	var forumURL = nconf.get('url');

	var webHookURLDefinitions = {};
	var postCategories = {};
	var number = 2;
	
	for (var i = 1; i < number; i++) {
		webHookURLDefinitions[i] = '';
		postCategories[i] = '';
	}
	
	var plugin = {
			config: {
				webhookURL: webHookURLDefinitions,
				maxLength: '',
				postCategories: postCategories,
				topicsOnly: '',
				messageContent: ''
			},
			regex: /https:\/\/discord(?:app)?\.com\/api\/webhooks\/([0-9]+?)\/(.+?)$/
		};

	plugin.init = function(params, callback) {
		function render(req, res, next) {
			res.render('admin/plugins/discord-notification', {});
		}

		params.router.get('/admin/plugins/discord-notification', params.middleware.admin.buildHeader, render);
		params.router.get('/api/admin/plugins/discord-notification', render);

		meta.settings.get('discord-notification', function(err, settings) {
			for (var prop in plugin.config) {
				if (settings.hasOwnProperty(prop)) {
					plugin.config[prop] = settings[prop];
				}
			}

			// Parse Webhook URL (1: ID, 2: Token)			
			var match;
			var webhookURLs = plugin.config['webhookURL'];			
			
			//for (var [key, value] of webhookURLs.entries()) {
			
			for(var [key, value] of Object.entries(webhookURLs)) {						
				match = value.match(plugin.regex);
				
				if (match) {
					hooks[key] = new Discord.WebhookClient(match[1], match[2]);
				}
				else {
					hooks[key] = null;	
				}
			}
			
			//var match = plugin.config['webhookURL'].match(plugin.regex);

			//if (match) {
			//	hook = new Discord.WebhookClient(match[1], match[2]);
			//}
		});

		callback();
	},

	plugin.postSave = function(post) {
		post = post.post;
		var topicsOnly = plugin.config['topicsOnly'] || 'off';

		if (topicsOnly === 'off' || (topicsOnly === 'on' && post.isMain)) {
			var content = post.content;

			async.parallel({
				user: function(callback) {
					User.getUserFields(post.uid, ['username', 'picture'], callback);
				},
				topic: function(callback) {
					Topics.getTopicFields(post.tid, ['title', 'slug'], callback);
				},
				category: function(callback) {
					Categories.getCategoryFields(post.cid, ['name', 'bgColor'], callback);
				}
			}, function(err, data) {
				var categories = JSON.parse(plugin.config['postCategories']);
				console.log(plugin.config['postCategories']);
				//var isAbleToBePosted = (!categories || categories.indexOf(String(post.cid)) >= 0); 

				var postAbilitations = {};
				var globalPostAbilitation = false;
								
				for (var [key, value] of Object.entries(categories)) {
					postAbilitations[key] = (!value || value.indexOf(String(post.cid)) >= 0);
					globalPostAbilitation = globalPostAbilitation || postAbilitations[key];
				}
				
				if (globalPostAbilitation) {
					// Trim long posts:
					var maxQuoteLength = plugin.config['maxLength'] || 1024;
					if (content.length > maxQuoteLength) { content = content.substring(0, maxQuoteLength) + '...'; }

					// Ensure absolute thumbnail URL if an avatar exists:
					var thumbnail = null;

					if (data.user.picture && data.user.picture.match(/^\//)) {
						thumbnail = forumURL + data.user.picture;
					} else if (data.user.picture) {
						thumbnail = data.user.picture;
					}

					// Add custom message:
					var messageContent = plugin.config['messageContent'] || '';

					// Make the rich embed:
					var embed = new Discord.MessageEmbed()
						.setColor(data.category.bgColor)
						.setURL(forumURL + '/topic/' + data.topic.slug)
						.setTitle(data.category.name + ': ' + data.topic.title)
						.setDescription(content)
						.setFooter(data.user.username, thumbnail)
						.setTimestamp();

					// Send notification:
					for (var [key, value] of Object.entries(postAbilitations)) {
						if (postAbilitations[key]) {
							
							var hook = hooks[key];
							console.log(hook);
							
							if (hook) {
								hook.send(messageContent, {embeds: [embed]}).catch(console.error);	
							}													
						}												
					}
										
					//if (hook) {
					//	hook.send(messageContent, {embeds: [embed]}).catch(console.error);
					//}
				}
			});
		}
	},

	plugin.addAdminMenu = function(header, callback) {
		translator.translate('[[discord-notification:title]]', function(title) {
			header.plugins.push({
				route : '/plugins/discord-notification',
				icon  : 'fa-bell',
				name  : title
			});

			callback(null, header);
		});
	};

	module.exports = plugin;

}(module));
