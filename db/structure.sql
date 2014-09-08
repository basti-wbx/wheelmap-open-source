CREATE TABLE `active_admin_comments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `resource_id` bigint(20) NOT NULL,
  `resource_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `author_id` bigint(20) DEFAULT NULL,
  `author_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `namespace` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_admin_notes_on_resource_type_and_resource_id` (`resource_type`,`resource_id`),
  KEY `index_active_admin_comments_on_namespace` (`namespace`),
  KEY `index_active_admin_comments_on_author_type_and_author_id` (`author_type`,`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `admin_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmation_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_admin_users_on_email` (`email`),
  UNIQUE KEY `index_admin_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_admin_users_on_confirmation_token` (`confirmation_token`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `alternatives` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `experiment_id` bigint(20) DEFAULT NULL,
  `content` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lookup` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `weight` int(11) DEFAULT '1',
  `participants` int(11) DEFAULT '0',
  `conversions` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_alternatives_on_experiment_id` (`experiment_id`),
  KEY `index_alternatives_on_lookup` (`lookup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `categories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `counters` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `counter_date` date DEFAULT NULL,
  `tag_website` int(11) DEFAULT '0',
  `tag_iphone` int(11) DEFAULT '0',
  `tag_android` int(11) DEFAULT '0',
  `update_website` int(11) DEFAULT '0',
  `update_iphone` int(11) DEFAULT '0',
  `update_android` int(11) DEFAULT '0',
  `create_website` int(11) DEFAULT '0',
  `create_iphone` int(11) DEFAULT '0',
  `create_android` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `search_website` int(11) DEFAULT '0',
  `search_iphone` int(11) DEFAULT '0',
  `search_android` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `delayed_jobs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
  `handler` text COLLATE utf8_unicode_ci,
  `last_error` text COLLATE utf8_unicode_ci,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `first_started_at` datetime DEFAULT NULL,
  `last_started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `queue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delayed_jobs_priority` (`priority`,`run_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `experiments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `test_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_experiments_on_test_name` (`test_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `iphone_counters` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `install_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `device_version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `app_version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `os_version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `node_types` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) DEFAULT NULL,
  `identifier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `osm_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `osm_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `icon` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `alt_osm_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `alt_osm_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_node_types_on_id_and_category_id` (`id`,`category_id`),
  KEY `index_node_types_on_osm_key_and_osm_value` (`osm_key`,`osm_value`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `photos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `caption` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `poi_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `taken_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `image_processing` tinyint(1) DEFAULT NULL,
  `image_tmp` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_width` int(11) DEFAULT NULL,
  `image_height` int(11) DEFAULT NULL,
  `image_gallery_ipad_retina_width` int(11) DEFAULT NULL,
  `image_gallery_ipad_retina_height` int(11) DEFAULT NULL,
  `image_thumb_width` int(11) DEFAULT NULL,
  `image_thumb_height` int(11) DEFAULT NULL,
  `image_thumb_iphone_width` int(11) DEFAULT NULL,
  `image_thumb_iphone_height` int(11) DEFAULT NULL,
  `image_thumb_iphone_retina_width` int(11) DEFAULT NULL,
  `image_thumb_iphone_retina_height` int(11) DEFAULT NULL,
  `image_gallery_iphone_width` int(11) DEFAULT NULL,
  `image_gallery_iphone_height` int(11) DEFAULT NULL,
  `image_gallery_iphone_retina_width` int(11) DEFAULT NULL,
  `image_gallery_iphone_retina_height` int(11) DEFAULT NULL,
  `image_gallery_ipad_width` int(11) DEFAULT NULL,
  `image_gallery_ipad_height` int(11) DEFAULT NULL,
  `image_gallery_width` int(11) DEFAULT NULL,
  `image_gallery_height` int(11) DEFAULT NULL,
  `image_gallery_preview_width` int(11) DEFAULT NULL,
  `image_gallery_preview_height` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `pois` (
  `osm_id` bigint(20) NOT NULL,
  `version` int(11) NOT NULL,
  `tags` text COLLATE utf8_unicode_ci NOT NULL,
  `geom` point NOT NULL,
  `status` mediumint(9) NOT NULL DEFAULT '8',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `node_type_id` bigint(20) DEFAULT NULL,
  `region_id` bigint(20) DEFAULT NULL,
  UNIQUE KEY `index_pois_on_osm_id` (`osm_id`),
  SPATIAL KEY `index_pois_on_geom` (`geom`),
  KEY `index_pois_on_status` (`status`),
  KEY `index_pois_on_node_type_id_and_osm_id` (`node_type_id`,`osm_id`),
  KEY `index_pois_on_region_id` (`region_id`),
  KEY `index_pois_on_node_type_id_and_osm_id_and_status` (`node_type_id`,`status`,`osm_id`),
  FULLTEXT KEY `fulltext_index_pois_on_tags` (`tags`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `provided_pois` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `poi_id` bigint(20) NOT NULL,
  `provider_id` bigint(20) NOT NULL,
  `wheelchair` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_provided_pois_on_provider_id_and_poi_id` (`provider_id`,`poi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `providers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `logo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `regions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `grenze` geometry NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `admin_level` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `slugs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sluggable_id` bigint(20) DEFAULT NULL,
  `sequence` int(11) NOT NULL DEFAULT '1',
  `sluggable_type` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scope` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_slugs_on_n_s_s_and_s` (`name`,`sluggable_type`,`sequence`,`scope`),
  KEY `index_slugs_on_sluggable_id` (`sluggable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `oauth_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `oauth_secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_salt` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `remember_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `changeset_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `authentication_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `wants_newsletter` tinyint(1) NOT NULL DEFAULT '0',
  `confirmation_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `osm_id` bigint(20) DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `create_counter` int(11) NOT NULL DEFAULT '0',
  `edit_counter` int(11) NOT NULL DEFAULT '0',
  `osm_username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag_counter` int(11) NOT NULL DEFAULT '0',
  `photos_count` int(11) NOT NULL DEFAULT '0',
  `terms` tinyint(1) NOT NULL DEFAULT '0',
  `accepted_at` datetime DEFAULT NULL,
  `privacy_policy` tinyint(1) NOT NULL DEFAULT '0',
  `privacy_policy_accepted_at` datetime DEFAULT NULL,
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_authentication_token` (`authentication_token`),
  KEY `index_users_on_oauth_token` (`oauth_token`),
  KEY `index_users_on_wants_newsletter` (`wants_newsletter`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20140904102249');