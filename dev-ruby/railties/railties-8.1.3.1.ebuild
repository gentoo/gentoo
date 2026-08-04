# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_TEST="test:isolated"
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="railties.gemspec"

RUBY_FAKEGEM_BINDIR="exe"
RUBY_FAKEGEM_BINWRAP=""

inherit edo multiprocessing ruby-fakegem

DESCRIPTION="Tools for creating, working with, and running Rails applications"
HOMEPAGE="https://github.com/rails/rails"

SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"
RUBY_S="rails-${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND=">=app-eselect/eselect-rails-0.29"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/irb-1.13:0
	>=dev-ruby/rackup-1.0.0
	>=dev-ruby/rake-12.2
	>=dev-ruby/thor-1.2.2:1
	>=dev-ruby/tsort-0.2
	>=dev-ruby/zeitwerk-2.6:2
"

ruby_add_bdepend "
	test? (
		~dev-ruby/actionmailer-${PV}
		~dev-ruby/actiontext-${PV}
		~dev-ruby/actionview-${PV}
		~dev-ruby/activestorage-${PV}
		>=dev-ruby/bcrypt-ruby-3.1.11
		>=dev-ruby/bootsnap-1.4.4
		dev-ruby/bundler
		>=dev-ruby/capybara-3.39
		dev-ruby/connection_pool
		<dev-ruby/dalli-5:*
		>=dev-ruby/dalli-3.0.1:*
		>=dev-ruby/image_processing-1.2:0
		>=dev-ruby/importmap-rails-1.2.3
		dev-ruby/jbuilder
		>=dev-ruby/listen-3.3:3
		dev-ruby/minitest:6
		dev-ruby/minitest-mock
		dev-ruby/minitest-retry
		>=dev-ruby/mysql2-0.5:0.5
		>=dev-ruby/propshaft-0.1.7
		>=dev-ruby/pg-1.3:1
		>=dev-ruby/rack-cache-1.2:1.2
		>=dev-ruby/ruby-vips-2.3
		>=dev-ruby/selenium-webdriver-4.20.0
		>=dev-ruby/sprockets-rails-2.0.0
		>=dev-ruby/sqlite3-2.1
		dev-ruby/web-console
		dev-ruby/webrick
		>=www-servers/puma-5.0.3
	)
"

all_ruby_prepare() {
	# Replace Gemfile with something simpler for the test run
	cat <<-EOF > ../Gemfile || die
	source "https://rubygems.org"
	gemspec

	gem "rake"

	gem "minitest", "~> 6.0"
	gem "minitest-mock"
	gem "minitest-retry"

	gem "actionmailer", "${PV}"
	gem "actiontext", "${PV}"
	gem "actionview", "${PV}"
	gem "activestorage", "${PV}"
	gem "bcrypt", "~> 3.1.11", require: false
	gem "bootsnap", ">= 1.4.4", require: false
	gem "capybara", ">= 3.39"
	gem "connection_pool", require: false
	gem "dalli", ">= 3.0.1", "< 5"
	gem "image_processing", "~> 1.2"
	gem "importmap-rails", ">= 1.2.3"
	gem "jbuilder", require: false
	gem "listen", "~> 3.3", require: false
	gem "mysql2", "~> 0.5"
	gem "pg", "~> 1.3"
	gem "propshaft", ">= 0.1.7"
	gem "puma", ">= 5.0.3", require: false
	gem "rack-cache", "~> 1.2"
	gem "ruby-vips", "~> 2.3"
	gem "selenium-webdriver", ">= 4.20.0"
	gem "sprockets-rails", ">= 2.0.0", require: false
	gem "sqlite3", ">= 2.1"
	gem "web-console", require: false
	gem "webrick", require: false
	EOF
	rm ../Gemfile.lock || die

	# Avoid rubocop dependency
	sed -e '/"generators with apply_rubocop_autocorrect_after_generate!"/,/^      end/ s:^:#:' \
		-e '/"generators with apply_rubocop_autocorrect_after_generate! and pretend"/,/^      end/ s:^:#:' \
		-i test/application/generators_test.rb || die
	sed -e '/def test_generated_files_have_no_rubocop_warnings/,/^  end/ s:^:#:' \
		-i test/generators/shared_generator_tests.rb || die

	# selenium chrome
	sed -e '/def generate_application_system_test_case_file/,/^      end/ s:^:#:' \
		-e '/def test_failed_system_test_screenshot_should_be_taken_before_other_teardown/,/^    end/ s:^:#:' \
		-e '/def test_parallel_testing_when_schema_is_not_up_to_date/,/^    end/ s:^:#:' \
		-e '/def test_reset_sessions_on_failed_system_test_screenshot/,/^    end/ s:^:#:' \
		-e '/def test_system_tests_are_not_run_through_rake_test/,/^    end/ s:^:#:' \
		-e '/def test_system_tests_are_not_run_with_the_default_test_command/,/^    end/ s:^:#:' \
		-e '/def test_system_tests_are_run_through_rake_test_when_given_in_TEST/,/^    end/ s:^:#:' \
		-i test/application/test_runner_test.rb || die
	rm test/application/system_test_case_test.rb || die

	# Unpackaged dependency turbo-rails
	sed -e '/def test_app_update$/,/^  end/ s:^:#:' \
		-e '/def test_app_update_does_not_change_app_name_when_app_name_is_hyphenated_name/,/^  end/ s:^:#:' \
		-e '/def test_app_update_does_not_change_config_target_version/,/^  end/ s:^:#:' \
		-e '/def test_app_update_does_not_generate_action_cable_contents_when_skip_action_cable_is_given/,/^  end/ s:^:#:' \
		-e '/def test_app_update_does_not_generate_active_storage_contents_when_skip_active_record_is_given/,/^  end/ s:^:#:' \
		-e '/def test_app_update_does_not_generate_active_storage_contents_when_skip_active_storage_is_given/,/^  end/ s:^:#:' \
		-e '/def test_app_update_does_not_generate_assets_initializer_when_asset_pipeline_is_not_used/,/^  end/ s:^:#:' \
		-e '/def test_app_update_does_not_generate_bootsnap_contents_when_skip_bootsnap_is_given/,/^  end/ s:^:#:' \
		-e '/def test_app_update_does_not_remove_rack_cors_if_already_present/,/^  end/ s:^:#:' \
		-e '/def test_app_update_generates_public_folders/,/^  end/ s:^:#:' \
		-e '/def test_app_update_preserves_skip_action_mailbox/,/^  end/ s:^:#:' \
		-e '/def test_app_update_preserves_skip_action_text/,/^  end/ s:^:#:' \
		-e '/def test_app_update_preserves_skip_active_job/,/^  end/ s:^:#:' \
		-e '/def test_app_update_preserves_skip_brakeman/,/^  end/ s:^:#:' \
		-e '/def test_app_update_preserves_skip_bundler_audit/,/^  end/ s:^:#:' \
		-e '/def test_app_update_preserves_skip_rubocop/,/^  end/ s:^:#:' \
		-e '/def test_app_update_preserves_skip_system_test/,/^  end/ s:^:#:' \
		-e '/def test_app_update_preserves_skip_test/,/^  end/ s:^:#:' \
		-e '/def test_app_update_preserves_skip_thruster/,/^  end/ s:^:#:' \
		-e '/def test_app_update_supports_pretend/,/^  end/ s:^:#:' \
		-e '/def test_app_update_supports_skip/,/^  end/ s:^:#:' \
		-e '/def test_application_name_is_detected_if_it_exists_and_app_folder_renamed/,/^  end/ s:^:#:' \
		-e '/def test_ci_workflow_does_not_include_db_test_prepare_when_skip_active_record_is_given/,/^  end/ s:^:#:' \
		-i test/generators/app_generator_test.rb || die

	# Avoid breaking network sandbox
	rm test/application/active_job_adapter_test.rb || die
	sed -e '/def test_ensure_that_migration_tasks_work_with_mountable_option/,/^  end/ s:^:#:' \
		-e '/def test_plugin_passes_generated_test/,/^  end/ s:^:#:' \
		-i test/generators/plugin_generator_test.rb || die

	# Needs running db
	sed -e '/test "db:create works when schema cache exists and database does not exist" do/,/^      end/ s:^:#:' \
		-e '/test "db:prepare creates test database if it does not exist" do/,/^      end/ s:^:#:' \
		-e '/test "db:schema:cache:dump dumps virtual columns" do/,/^      end/ s:^:#:' \
		-i test/application/rake/dbs_test.rb || die
	sed -e '/"default schema generation after migration"/,/^      end/ s:^:#:' \
		-e '/"migrate with specified VERSION in different formats"/,/^      end/ s:^:#:' \
		-e '/"migration status after rollback and forward"/,/^      end/ s:^:#:' \
		-e '/"migration status after rollback and redo without timestamps"/,/^      end/ s:^:#:' \
		-e '/"migration status after rollback and redo"/,/^      end/ s:^:#:' \
		-e '/"migration status migrated file is deleted"/,/^      end/ s:^:#:' \
		-e '/"migration status without timestamps"/,/^      end/ s:^:#:' \
		-e '/"migration status"/,/^      end/ s:^:#:' \
		-e '/"migration with 0 version"/,/^      end/ s:^:#:' \
		-e '/"migration with empty version"/,/^      end/ s:^:#:' \
		-e '/"migrations with execute run when connections are established from a loaded model"/,/^      end/ s:^:#:' \
		-e '/"model and migration generator with change syntax"/,/^      end/ s:^:#:' \
		-e '/"raise error on any move when current migration does not exist"/,/^      end/ s:^:#:' \
		-e '/"raise error on any move when target migration does not exist"/,/^      end/ s:^:#:' \
		-e '/"running migrations with given scope"/,/^      end/ s:^:#:' \
		-e '/"running migrations with not timestamp head migration files"/,/^      end/ s:^:#:' \
		-e '/"version outputs current version"/,/^      end/ s:^:#:' \
		-i test/application/rake/migrations_test.rb || die
	sed -e '/test "db:migrate respects timestamp ordering across databases" do/,/^      end/ s:^:#:' \
		-e '/test "db:prepare setup the database even if schema does not exist" do/,/^      end/ s:^:#:' \
		-e '/test "db:prepare setups missing database without clearing existing one" do/,/^      end/ s:^:#:' \
		-i test/application/rake/multi_dbs_test.rb || die
	sed -e '/test "task is protected when previous migration was production" do/,/^    end/ s:^:#:' \
		-i test/application/rake_test.rb || die
	sed -e '/"database-dependent attribute types are resolved when parallel tests are run in eager load context"/,/^    end/ s:^:#:' \
		-i test/application/test_test.rb || die
	sed -e '/test_devcontainer_mariadb_mysql/,/^  end/ s:^:#:' \
		-e '/test_devcontainer_mysql/,/^  end/ s:^:#:' \
		-i test/generators/app_generator_test.rb || die

	# Unpackaged dependency solid_cable and solid_queue
	sed -e '/test "generates devcontainer for default app with solid gems" do/,/^  end/ s:^:#:' \
		-i test/commands/devcontainer_test.rb || die
	sed -e '/def test_app_update_does_not_generate_public_files/,/^  end/ s:^:#:' \
		-i test/generators/api_app_generator_test.rb || die

	# Unpackaged dependency kamal
	sed -e '/test_kamal_deploy_yml_excludes_asset_path_for_api_app/,/^  end/ s:^:#:' \
		-i test/generators/api_app_generator_test.rb || die

	# Fails due to using system gems
	sed -e '/"rails routes with expanded option"/,/^  end/ s:^:#:' \
		-i test/commands/routes_test.rb || die

	# Triggers vendored thor in bundler weirdness
	sed -e '/test_bin_setup$/,/^    end/ s:^:#:' \
		-e '/test_bin_setup_output/,/^    end/ s:^:#:' \
		-i test/application/bin_setup_test.rb || die
	sed -e '/"load_path is populated before eager loaded models"/,/^    end/ s:^:#:' \
		-e '/"locale files should be added to the load path"/,/^    end/ s:^:#:' \
		-i test/application/initializers/i18n_test.rb || die
	sed -e '/"AC load hooks can be used with metal"/,/^  end/ s:^:#:' \
		-e '/"constants in app are autoloaded"/,/^  end/ s:^:#:' \
		-e '/"frameworks aren.t loaded during initialization"/,/^  end/ s:^:#:' \
		-e '/"models without table do not panic on scope definitions when loaded"/,/^  end/ s:^:#:' \
		-e '/test_initialize_can_be_called_at_any_time/,/^  end/ s:^:#:' \
		-i test/application/loading_test.rb || die
	sed -e '/test_console_command_work_inside_engine/,/^    end/ s:^:#:' \
		-e '/test_dbconsole_command_work_inside_engine/,/^    end/ s:^:#:' \
		-e '/test_help_command_work_inside_engine/,/^  end/ s:^:#:' \
		-e '/test_runner_command_work_inside_engine/,/^  end/ s:^:#:' \
		-e '/test_server_command_broadcast_logs/,/^    end/ s:^:#:' \
		-e '/test_server_command_work_inside_engine/,/^    end/ s:^:#:' \
		-i test/engine/commands_test.rb || die
	sed -e '/"automatically synchronize test schema"/,/^  end/ s:^:#:' \
		-i test/engine/test_test.rb || die
	sed -e '/test_executed_only_once/,/^  end/ s:^:#:' \
		-e '/test_fail_fast/,/^  end/ s:^:#:' \
		-e '/test_mix_files_and_line_filters/,/^  end/ s:^:#:' \
		-e '/test_multiple_line_filters/,/^  end/ s:^:#:' \
		-e '/test_only_inline_failure_output/,/^  end/ s:^:#:' \
		-e '/test_output_inline_by_default/,/^  end/ s:^:#:' \
		-e '/test_raise_error_when_specified_file_does_not_exist/,/^  end/ s:^:#:' \
		-e '/test_run_default/,/^  end/ s:^:#:' \
		-e '/test_run_multiple_files/,/^  end/ s:^:#:' \
		-e '/test_run_single_file/,/^  end/ s:^:#:' \
		-e '/test_warnings_option/,/^  end/ s:^:#:' \
		-i test/generators/plugin_test_runner_test.rb || die
	sed -e '/test_controller_tests_pass_by_default_inside_full_engine/,/^  end/ s:^:#:' \
		-e '/test_controller_tests_pass_by_default_inside_mountable_engine/,/^  end/ s:^:#:' \
		-i test/generators/scaffold_controller_generator_test.rb || die
	sed -e '/test_scaffold_on_invoke_inside_mountable_engine/,/^  end/ s:^:#:' \
		-e '/test_scaffold_on_revoke_inside_mountable_engine/,/^  end/ s:^:#:' \
		-e '/test_scaffold_tests_pass_by_default_inside_api_full_engine/,/^  end/ s:^:#:' \
		-e '/test_scaffold_tests_pass_by_default_inside_api_mountable_engine/,/^  end/ s:^:#:' \
		-e '/test_scaffold_tests_pass_by_default_inside_full_engine/,/^  end/ s:^:#:' \
		-e '/test_scaffold_tests_pass_by_default_inside_mountable_engine/,/^  end/ s:^:#:' \
		-e '/test_scaffold_tests_pass_by_default_inside_namespaced_mountable_engine/,/^  end/ s:^:#:' \
		-i test/generators/scaffold_generator_test.rb || die
	sed -e '/test_run_default/,/^  end/ s:^:#:' \
		-e '/test_rerun_snippet_is_relative_path/,/^  end/ s:^:#:' \
		-i test/generators/test_runner_in_engine_test.rb || die
	sed -e '/"active_storage:install task works within engine"/,/^    end/ s:^:#:' \
		-e '/"active_storage:update task works within engine"/,/^    end/ s:^:#:' \
		-e '/"adds its fixtures path to fixture_paths"/,/^    end/ s:^:#:' \
		-e '/"adds its mailer previews to mailer preview paths"/,/^    end/ s:^:#:' \
		-e '/"adds its views to view paths"/,/^    end/ s:^:#:' \
		-e '/"can draw routes in app routes from engines"/,/^    end/ s:^:#:' \
		-e '/"copying migrations to specific database"/,/^    end/ s:^:#:' \
		-e '/"copying migrations"/,/^    end/ s:^:#:' \
		-e '/"don.t reverse default railties order"/,/^    end/ s:^:#:' \
		-e '/"isolated engine should avoid namespace in names if that.s possible"/,/^    end/ s:^:#:' \
		-e '/"loading seed data is wrapped by the executor"/,/^    end/ s:^:#:' \
		-e '/"locales can be nested"/,/^    end/ s:^:#:' \
		-e '/"mountable engine should copy migrations within engine_path"/,/^    end/ s:^:#:' \
		-e '/"puts its lib directory on load path"/,/^    end/ s:^:#:' \
		-e '/"rake environment can be called in the engine"/,/^    end/ s:^:#:' \
		-e '/"respects the order of railties when installing migrations"/,/^    end/ s:^:#:' \
		-e '/"skips nonexistent seed data"/,/^    end/ s:^:#:' \
		-e '/"take ActiveRecord table_name_prefix into consideration when defining table_name_prefix"/,/^    end/ s:^:#:' \
		-e '/"using namespace more than once on one module should not overwrite railtie_namespace method"/,/^    end/ s:^:#:' \
		-e '/"when the bootstrap hook runs, autoload paths are set"/,/^    end/ s:^:#:' \
		-i test/railties/engine_test.rb || die
	sed -e '/test_controllers_are_correctly_namespaced_when_engine_is_mountable/,/^    end/ s:^:#:' \
		-e '/test_controllers_are_not_namespaced_when_engine_is_not_mountable/,/^    end/ s:^:#:' \
		-e '/test_helpers_are_correctly_namespaced_when_engine_is_mountable/,/^    end/ s:^:#:' \
		-e '/test_helpers_are_not_namespaced_when_engine_is_not_mountable/,/^    end/ s:^:#:' \
		-e '/test_models_are_correctly_namespaced_when_engine_is_mountable/,/^    end/ s:^:#:' \
		-e '/test_models_are_not_namespaced_when_engine_is_not_mountable/,/^    end/ s:^:#:' \
		-e '/test_table_name_prefix_is_correctly_namespaced_when_engine_is_mountable/,/^    end/ s:^:#:' \
		-i test/railties/generators_test.rb || die

	# Hangs
	sed -e '/test "routes are loaded before inserting test routes" do/,/^    end/ s:^:#:' \
		-i test/application/integration_test_case_test.rb || die
	sed -e '/test "app lazily loads routes when polymorphic_url is called" do/,/^      end/ s:^:#:' \
		-i test/engine/lazy_route_set_test.rb || die

	# FIXME:
	sed -e '/test_default_transformer_with_gem_no_warning/,/^    end/ s:^:#:' \
		-i test/application/active_storage/engine_integration_test.rb || die
	sed -e '/"db:prepare runs seeds once"/,/^      end/ s:^:#:' \
		-i test/application/rake/multi_dbs_test.rb || die
	sed -e '/test_not_protected_when_previous_migration_was_not_production/,/^    end/ s:^:#:' \
		-i test/application/rake_test.rb || die
	sed -e '/test_can_exclude_files_from_being_tested_via_rake_task_by_setting_DEFAULT_TEST_EXCLUDE_env_var/,/^    end/ s:^:#:' \
		-e '/test_parallelization_is_disabled_when_number_of_tests_is_below_threshold/,/^    end/ s:^:#:' \
		-e '/test_pass_TEST_env_on_rake_test/,/^    end/ s:^:#:' \
		-e '/test_pass_rake_options/,/^    end/ s:^:#:' \
		-e '/test_rails_db_create_all_restores_db_connection$/,/^    end/ s:^:#:' \
		-e '/test_rails_db_create_all_restores_db_connection_after_drop/,/^    end/ s:^:#:' \
		-e '/test_rake_db_and_test_tasks_parses_args_correctly/,/^    end/ s:^:#:' \
		-e '/test_rake_passes_TESTOPTS_to_minitest/,/^    end/ s:^:#:' \
		-e '/test_rake_passes_multiple_TESTOPTS_to_minitest/,/^    end/ s:^:#:' \
		-e '/test_rake_runs_multiple_test_tasks/,/^    end/ s:^:#:' \
		-e '/test_rake_runs_tests_before_other_tasks_when_specified/,/^    end/ s:^:#:' \
		-e '/test_reset_sessions_before_rollback_on_system_tests/,/^    end/ s:^:#:' \
		-i test/application/test_runner_test.rb || die
	sed -e '/test "when passing --trace it invokes default" do/,/^  end/ s:^:#:'\
		-i test/command/help_integration_test.rb || die
	sed -e '/test_app_update_silence_deprecate_message/,/^  end/ s:^:#:' \
		-i test/generators/app_generator_test.rb || die
}

each_ruby_test() {
	# https://github.com/rails/rails/blob/main/guides/source/testing.md#parallel-testing
	local -x PARALLEL_WORKERS="$(get_makeopts_jobs)"

	local -x BUNDLE_GEMFILE="../Gemfile"
	local -x MT_NO_PLUGINS=true
	# Do not include --disable=did_you_mean, its expected by some tests
	edo ${RUBY} -S bundle exec ${RUBY} -S rake ${RUBY_FAKEGEM_TASK_TEST} || die
}

all_ruby_install() {
	all_fakegem_install

	ruby_fakegem_binwrapper rails rails-${PV}
}

pkg_postinst() {
	elog "To select between slots of rails, use:"
	elog "\teselect rails"

	eselect rails update
}

pkg_postrm() {
	eselect rails update
}
