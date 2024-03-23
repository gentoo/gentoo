# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_1{0..2} )

DISTUTILS_USE_PEP517=setuptools
inherit systemd distutils-r1

DESCRIPTION="Salt is a remote execution and configuration manager"
HOMEPAGE="https://www.saltstack.com/resources/community/
	https://github.com/saltstack"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}stack/${PN}.git"
	EGIT_BRANCH="develop"
else
	inherit pypi
	KEYWORDS="~amd64 ~riscv ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="
	cheetah cherrypy ldap libcloud libvirt genshi gnupg keyring mako
	mongodb neutron	nova portage profile redis selinux test raet
	+zeromq vim-syntax
"

RDEPEND="
	sys-apps/pciutils
	dev-libs/openssl:0=[-bindist(-)]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	>=dev-python/cherrypy-18.6.1[${PYTHON_USEDEP}]
	>=dev-python/cryptography-42.0.0[${PYTHON_USEDEP}]
	>=dev-python/distro-1.5[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.1.3[${PYTHON_USEDEP}]
	dev-python/jmespath[${PYTHON_USEDEP}]
	dev-python/libnacl[${PYTHON_USEDEP}]
	dev-python/looseversion[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.19.1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-24.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.1[${PYTHON_USEDEP}]
	dev-python/python-gnupg[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.1[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.1.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/tornado[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	libcloud? (
		>=dev-python/aiohttp-3.9.0[${PYTHON_USEDEP}]
		dev-python/aiosignal[${PYTHON_USEDEP}]
		>=dev-python/apache-libcloud-2.5.0[${PYTHON_USEDEP}]
		dev-python/async-timeout[${PYTHON_USEDEP}]
	)
	mako? ( dev-python/mako[${PYTHON_USEDEP}] )
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )
	libvirt? (
		dev-python/libvirt-python[${PYTHON_USEDEP}]
	)
	raet? (
		>=dev-python/libnacl-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/ioflo-1.1.7[${PYTHON_USEDEP}]
		>=dev-python/raet-0.6.0[${PYTHON_USEDEP}]
	)
	cheetah? ( >=dev-python/cheetah3-3.2.2[${PYTHON_USEDEP}] )
	genshi? ( dev-python/genshi[${PYTHON_USEDEP}] )
	mongodb? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	portage? ( sys-apps/portage[${PYTHON_USEDEP}] )
	keyring? ( dev-python/keyring[${PYTHON_USEDEP}] )
	redis? ( dev-python/redis[${PYTHON_USEDEP}] )
	selinux? ( sec-policy/selinux-salt )
	nova? (
		$(python_gen_cond_dep '>=dev-python/python-novaclient-2.17.0[${PYTHON_USEDEP}]' python3.1{0..1})
	)
	neutron? (
		$(python_gen_cond_dep '>=dev-python/python-neutronclient-2.3.6[${PYTHON_USEDEP}]' python3.1{0..1})
	)
	gnupg? ( dev-python/python-gnupg[${PYTHON_USEDEP}] )
	profile? ( dev-python/yappi[${PYTHON_USEDEP}] )
	vim-syntax? ( app-vim/salt-vim )
	zeromq? ( >=dev-python/pyzmq-19.0.0[${PYTHON_USEDEP}] )
"
BDEPEND="
	sys-apps/findutils
	dev-python/build[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		app-arch/zip
		dev-python/apache-libcloud[${PYTHON_USEDEP}]
		dev-python/boto3[${PYTHON_USEDEP}]
		>=dev-python/certifi-2023.07.22[${PYTHON_USEDEP}]
		dev-python/cherrypy[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]
		dev-python/mako[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/moto-2.0.0[${PYTHON_USEDEP}]
		<dev-python/moto-5[${PYTHON_USEDEP}]
		dev-python/passlib[${PYTHON_USEDEP}]
		dev-python/bcrypt[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pygit2[${PYTHON_USEDEP}]
		dev-python/pyinotify[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-23.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-salt-factories-1.0.0_rc29[${PYTHON_USEDEP}]
		dev-python/pytest-tempdir[${PYTHON_USEDEP}]
		dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
		dev-python/pytest-shell-utilities[${PYTHON_USEDEP}]
		dev-python/pytest-skip-markers[${PYTHON_USEDEP}]
		dev-python/pytest-system-statistics[${PYTHON_USEDEP}]
		dev-python/pytest-custom-exit-code[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		net-dns/bind-tools
		>=dev-python/virtualenv-20.3.0[${PYTHON_USEDEP}]
		dev-util/yamllint[${PYTHON_USEDEP}]
		!x86? ( >=dev-python/boto3-1.21.46[${PYTHON_USEDEP}] )
	)
"

DOCS=( README.rst AUTHORS )

REQUIRED_USE="
	|| ( raet zeromq )
	test? ( cheetah genshi )
	nova? ( || ( python_targets_python3_10 python_targets_python3_11 ) )
	neutron? ( || ( python_targets_python3_10 python_targets_python3_11 ) )
"
RESTRICT="
	!test? ( test )
	x86? ( test )
"

PATCHES=(
	"${FILESDIR}/salt-3003-gentoolkit-revdep.patch"
)

python_prepare_all() {
	local -a remove_test_files=(
		# remove tests with external dependencies that may not be available, and
		# tests that don't work in sandbox
		tests/integration/externalapi/test_venafiapi.py
		tests/integration/modules/test_rabbitmq.py
		tests/integration/modules/test_supervisord.py
		tests/integration/states/test_match.py
		tests/pytests/functional/fileserver/hgfs/test_hgfs.py
		tests/pytests/functional/loader/test_loader.py
		tests/pytests/functional/modules/file/test_readlink.py
		tests/pytests/functional/modules/file/test_symlink.py
		tests/pytests/functional/modules/state/test_jinja_filters.py
		tests/pytests/functional/modules/state/test_jinja_renderer.py
		tests/pytests/functional/modules/state/test_mako_renderer.py
		tests/pytests/functional/modules/state/test_pyobjects_renderer.py
		tests/pytests/functional/modules/test_aptpkg.py
		tests/pytests/functional/modules/test_dockermod.py
		tests/pytests/functional/modules/test_etcd_mod.py
		tests/pytests/functional/modules/test_grains.py
		tests/pytests/functional/modules/test_mac_service.py
		tests/pytests/functional/modules/test_saltcheck.py
		tests/pytests/functional/modules/test_saltutil.py
		tests/pytests/functional/modules/test_test.py
		tests/pytests/functional/pillar/hg_pillar/test_hg_pillar.py
		tests/pytests/functional/pillar/test_git_pillar.py
		tests/pytests/functional/pillar/test_gpg.py
		tests/pytests/functional/returners/test_etcd_return.py
		tests/pytests/functional/runners/test_winrepo.py
		tests/pytests/functional/sdb/test_etcd_db.py
		tests/pytests/functional/state/test_masterless_tops.py
		tests/pytests/functional/states/file/test_keyvalue.py
		tests/pytests/functional/states/file/test_patch.py
		tests/pytests/functional/states/file/test_rename.py
		tests/pytests/functional/states/rabbitmq
		tests/pytests/functional/states/test_docker_container.py
		tests/pytests/functional/states/test_docker_network.py
		tests/pytests/functional/states/test_etcd_mod.py
		tests/pytests/functional/states/test_module.py
		tests/pytests/functional/states/test_mysql.py
		tests/pytests/functional/states/test_svn.py
		tests/pytests/functional/states/test_virtualenv_mod.py
		tests/pytests/functional/test_version.py
		tests/pytests/functional/utils/test_vault.py
		tests/pytests/integration/cli/test_syndic_eauth.py
		tests/pytests/integration/daemons/test_memory_leak.py
		tests/pytests/integration/grains/test_grains.py
		tests/pytests/integration/master/test_clear_funcs.py
		tests/pytests/integration/minion/test_reauth.py
		tests/pytests/integration/modules/grains/test_append.py
		tests/pytests/integration/modules/grains/test_module.py
		tests/pytests/integration/modules/saltutil/test_grains.py
		tests/pytests/integration/modules/saltutil/test_modules.py
		tests/pytests/integration/modules/saltutil/test_wheel.py
		tests/pytests/integration/modules/state/test_state_pillar_errors.py
		tests/pytests/integration/modules/state/test_state_test.py
		tests/pytests/integration/modules/test_cmdmod.py
		tests/pytests/integration/modules/test_event.py
		tests/pytests/integration/modules/test_file.py
		tests/pytests/integration/modules/test_jinja.py
		tests/pytests/integration/modules/test_pillar.py
		tests/pytests/integration/modules/test_pip.py
		tests/pytests/integration/modules/test_vault.py
		tests/pytests/integration/modules/test_virt.py
		tests/pytests/integration/modules/test_x509_v2.py
		tests/pytests/integration/proxy/test_deltaproxy.py
		tests/pytests/integration/proxy/test_shell.py
		tests/pytests/integration/reactor/test_reactor.py
		tests/pytests/integration/returners/test_noop_return.py
		tests/pytests/integration/runners/state/orchestrate/test_orchestrate.py
		tests/pytests/integration/runners/test_cache.py
		tests/pytests/integration/runners/test_jobs.py
		tests/pytests/integration/runners/test_manage.py
		tests/pytests/integration/runners/test_saltutil.py
		tests/pytests/integration/runners/test_vault.py
		tests/pytests/integration/sdb/test_vault.py
		tests/pytests/integration/ssh/state/test_pillar_override.py
		tests/pytests/integration/ssh/state/test_retcode_highstate_verification_requisite_fail.py
		tests/pytests/integration/ssh/state/test_retcode_pillar_render_exception.py
		tests/pytests/integration/ssh/state/test_retcode_render_exception.py
		tests/pytests/integration/ssh/state/test_retcode_render_module_exception.py
		tests/pytests/integration/ssh/state/test_retcode_run_fail.py
		tests/pytests/integration/ssh/state/test_retcode_state_run_remote_exception.py
		tests/pytests/integration/ssh/state/test_state.py
		tests/pytests/integration/ssh/state/test_with_import_dir.py
		tests/pytests/integration/ssh/test_cmdmod.py
		tests/pytests/integration/ssh/test_config.py
		tests/pytests/integration/ssh/test_cp.py
		tests/pytests/integration/ssh/test_deploy.py
		tests/pytests/integration/ssh/test_grains.py
		tests/pytests/integration/ssh/test_jinja_mods.py
		tests/pytests/integration/ssh/test_master.py
		tests/pytests/integration/ssh/test_mine.py
		tests/pytests/integration/ssh/test_pillar.py
		tests/pytests/integration/ssh/test_pillar_compilation.py
		tests/pytests/integration/ssh/test_pre_flight.py
		tests/pytests/integration/ssh/test_publish.py
		tests/pytests/integration/ssh/test_py_versions.py
		tests/pytests/integration/ssh/test_raw.py
		tests/pytests/integration/ssh/test_saltcheck.py
		tests/pytests/integration/ssh/test_slsutil.py
		tests/pytests/integration/states/test_beacon.py
		tests/pytests/integration/states/test_file.py
		tests/pytests/integration/states/test_include.py
		tests/pytests/integration/states/test_ini_manage.py
		tests/pytests/integration/states/test_state_test.py
		tests/pytests/integration/states/test_x509_v2.py
		tests/pytests/integration/utils/test_templates.py
		tests/pytests/integration/wheel/test_key.py
		tests/pytests/pkg/integration/test_check_imports.py
		tests/pytests/pkg/integration/test_clean_zmq_teardown.py
		tests/pytests/pkg/integration/test_enabled_disabled.py
		tests/pytests/pkg/integration/test_help.py
		tests/pytests/pkg/integration/test_logrotate_config.py
		tests/pytests/pkg/integration/test_pkg.py
		tests/pytests/pkg/integration/test_python.py
		tests/pytests/scenarios/compat/test_with_versions.py
		tests/pytests/unit/loader/test_lazy.py
		tests/pytests/unit/modules/test_mongodb.py
		tests/pytests/unit/modules/test_mysql.py
		tests/pytests/unit/modules/test_schedule.py
		tests/pytests/unit/pillar/test_consul_pillar.py
		tests/pytests/unit/pillar/test_mysql.py
		tests/pytests/unit/renderers/test_yamlex.py
		tests/pytests/unit/roster/test_ansible.py
		tests/pytests/unit/roster/test_dir.py
		tests/pytests/unit/runners/test_reactor.py
		tests/pytests/unit/states/file/test_keyvalue.py
		tests/pytests/unit/utils/jinja/test_get_template.py
		tests/pytests/unit/utils/jinja/test_salt_cache_loader.py
		tests/pytests/unit/utils/test_cache.py
		tests/pytests/unit/utils/test_etcd_util.py
		tests/pytests/unit/utils/test_package.py
		tests/pytests/unit/utils/test_versions.py
		tests/unit/ext/test_ipaddress.py
		tests/unit/modules/test_boto_elb.py
		tests/unit/modules/test_boto_secgroup.py
		tests/unit/modules/test_boto_vpc.py
		tests/unit/modules/test_elasticsearch.py
		tests/unit/modules/test_k8s.py
		tests/unit/modules/test_kubernetesmod.py
		tests/unit/modules/test_vsphere.py
		tests/unit/netapi/rest_tornado/test_saltnado.py
		tests/unit/states/test_boto_vpc.py
		tests/unit/states/test_module.py
		tests/unit/test_module_names.py
		tests/unit/test_zypp_plugins.py
		tests/unit/utils/test_extend.py
		tests/unit/utils/test_pbm.py
		tests/unit/utils/test_schema.py
		tests/unit/utils/test_vmware.py
		tests/unit/utils/test_vsan.py

		# tests that require network access
		tests/integration/cloud
		tests/integration/netapi
		tests/kitchen/test_kitchen.py
		tests/kitchen/tests/wordpress/tests
		tests/pytests/functional/cli/test_salt_cloud.py
		tests/pytests/functional/cli/test_salt_run_.py
		tests/pytests/functional/modules/test_ansiblegate.py
		tests/pytests/functional/modules/test_http.py
		tests/pytests/functional/modules/test_pip.py
		tests/pytests/functional/netapi
		tests/pytests/functional/utils/test_etcd_util.py
		tests/pytests/functional/utils/test_http.py
		tests/pytests/integration/cli/test_salt_proxy.py
		tests/pytests/integration/daemons/test_masterapi.py
		tests/pytests/integration/modules/state/test_state.py
		tests/pytests/integration/modules/state/test_state_state_events.py
		tests/pytests/integration/netapi
		tests/pytests/integration/pillar/cache/test_pillar_cache.py
		tests/pytests/integration/pillar/test_fileclient.py
		tests/pytests/integration/pillar/test_pillar_include.py
		tests/pytests/integration/proxy/test_simple.py
		tests/pytests/integration/runners/state/orchestrate/test_events.py
		tests/pytests/integration/wheel/test_pillar_roots.py
		tests/pytests/pkg/downgrade/test_salt_downgrade.py
		tests/pytests/pkg/integration/test_pip.py
		tests/pytests/pkg/integration/test_pip_upgrade.py
		tests/pytests/pkg/integration/test_salt_api.py
		tests/pytests/pkg/integration/test_salt_call.py
		tests/pytests/pkg/integration/test_salt_exec.py
		tests/pytests/pkg/integration/test_salt_grains.py
		tests/pytests/pkg/integration/test_salt_key.py
		tests/pytests/pkg/integration/test_salt_minion.py
		tests/pytests/pkg/integration/test_salt_output.py
		tests/pytests/pkg/integration/test_salt_pillar.py
		tests/pytests/pkg/integration/test_salt_state_file.py
		tests/pytests/pkg/integration/test_salt_ufw.py
		tests/pytests/pkg/integration/test_salt_user.py
		tests/pytests/pkg/integration/test_systemd_config.py
		tests/pytests/pkg/integration/test_version.py
		tests/pytests/pkg/upgrade/test_salt_upgrade.py
		tests/pytests/scenarios/cluster/test_cluster.py
		tests/pytests/unit/client/ssh/test_ssh.py
		tests/pytests/unit/cloud/clouds/vmware
		tests/pytests/unit/loader/test_loading_modules.py
		tests/pytests/unit/runners/test_net.py
		tests/pytests/unit/states/file/test_mod_beacon.py
		tests/pytests/unit/test_client.py
		tests/pytests/unit/utils/test_aws.py
		tests/pytests/unit/utils/test_http.py
		tests/unit/modules/test_boto3_elasticsearch.py
		tests/unit/modules/test_boto3_route53.py
		tests/unit/modules/test_network.py
		tests/unit/modules/test_zcbuildout.py
		tests/unit/states/test_zcbuildout.py

		# tests require root access
		tests/integration/pillar/test_git_pillar.py
		tests/integration/states/test_lxd_container.py
		tests/integration/states/test_lxd_image.py
		tests/integration/states/test_lxd_profile.py
		tests/integration/states/test_supervisord.py
		tests/pytests/functional/cache/test_mysql.py
		tests/pytests/functional/cli/test_salt.py
		tests/pytests/functional/modules/test_mysql.py
		tests/pytests/functional/modules/test_vault.py
		tests/pytests/functional/states/file/test_accumulated.py
		tests/pytests/functional/utils/test_gitfs.py
		tests/pytests/functional/utils/test_pillar.py
		tests/pytests/scenarios/performance/test_performance.py
		tests/pytests/unit/cloud/test_map.py
		tests/pytests/unit/engines/test_slack_bolt_engine.py
		tests/pytests/unit/modules/state/test_state.py
		tests/pytests/unit/modules/state/test_top_file_merge.py
		tests/pytests/unit/proxy/test_netmiko_px.py
		tests/pytests/unit/proxy/test_ssh_sample.py
		tests/pytests/unit/roster/test_sshknownhosts.py

		# tests that require boto
		tests/pytests/unit/engines/test_sqs_events.py

		# first test always fails
		tests/pytests/unit/utils/parsers/test_log_parsers.py
	)

	rm -r "${remove_test_files[@]}" || die

	# axe the boto dep (bug #888235)
	find "${S}/tests" -name 'test_boto_*.py' -delete || die

	# removes contextvars, see bug: https://bugs.gentoo.org/799431
	sed -i '/^contextvars/d' requirements/base.txt || die

	# called_once should be assert_called_once_with
	find "${S}/tests" -name '*.py' -print0 \
		| xargs -0 -- sed -i -e 's:[.]called_once:.assert_called_once:g' -- || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	local -x USE_SETUPTOOLS=1
	distutils-r1_python_install_all

	local svc
	for svc in minion master syndic api; do
		newinitd "${FILESDIR}"/${svc}-initd-5 salt-${svc}
		newconfd "${FILESDIR}"/${svc}-confd-1 salt-${svc}
		systemd_dounit "${FILESDIR}"/salt-${svc}.service
	done

	insinto /etc/${PN}
	doins -r conf/*
}

python_test() {
	local -a EPYTEST_DESELECT=(
		# doesn't like the distutils warning
		tests/pytests/integration/cli/test_batch.py::test_batch_retcode
		tests/pytests/integration/cli/test_batch.py::test_multiple_modules_in_batch

		# hangs indefinitely
		tests/pytests/unit/test_minion.py::test_master_type_disable

		# needs root
		tests/pytests/unit/modules/test_cmdmod.py::test_runas_env_sudo_group
		tests/pytests/unit/modules/test_portage_config.py::test_enforce_nice_config
		tests/unit/modules/test_saltcheck.py::SaltcheckTestCase::test_run_test_muliassert
		tests/unit/modules/test_saltcheck.py::SaltcheckTestCase::test_run_test_muliassert_failure

		# don't like sandbox
		tests/integration/modules/test_cp.py::CPModuleTest::test_get_file_str_https
		tests/integration/modules/test_cp.py::CPModuleTest::test_get_url_ftp
		tests/integration/modules/test_cp.py::CPModuleTest::test_get_url_https
		tests/integration/modules/test_cp.py::CPModuleTest::test_get_url_https_dest_empty
		tests/integration/modules/test_cp.py::CPModuleTest::test_get_url_https_no_dest
		tests/integration/states/test_git.py::LocalRepoGitTest::test_latest_force_reset_true_fast_forward
		tests/pytests/functional/fileserver/test_roots.py::test_symlink_list
		tests/pytests/functional/modules/file/test_replace.py::test_append_if_not_found_content
		tests/pytests/functional/modules/file/test_replace.py::test_append_if_not_found_empty_file
		tests/pytests/functional/modules/file/test_replace.py::test_append_if_not_found_no_append_on_match
		tests/pytests/functional/modules/file/test_replace.py::test_append_if_not_found_no_match_newline
		tests/pytests/functional/modules/file/test_replace.py::test_append_if_not_found_no_match_no_newline
		tests/pytests/functional/modules/test_defaults.py::test_defaults_get
		tests/pytests/functional/modules/test_system.py::test_get_system_date_time
		tests/pytests/functional/modules/test_system.py::test_get_system_date_time_utc
		tests/pytests/functional/pillar/test_top.py::test_pillar_top_compound_match
		tests/pytests/functional/states/file/test_append.py::test_file_append_check_cmd
		tests/pytests/functional/states/file/test_append.py::test_issue_1896_file_append_source
		tests/pytests/functional/states/file/test_blockreplace.py::test_issue_49043
		tests/pytests/functional/states/file/test_comment.py::test_issue_62121
		tests/pytests/functional/states/file/test_directory.py::test_directory_clean_require_in
		tests/pytests/functional/states/file/test_directory.py::test_directory_clean_require_in_with_id
		tests/pytests/functional/states/file/test_directory.py::test_directory_clean_require_with_name
		tests/pytests/functional/states/file/test_managed.py::test_file_managed_requisites
		tests/pytests/functional/states/file/test_managed.py::test_issue_8947_utf8_sls
		tests/pytests/functional/states/file/test_managed.py::test_managed_escaped_file_path
		tests/pytests/functional/states/file/test_managed.py::test_managed_file_issue_51208
		tests/pytests/functional/states/file/test_managed.py::test_managed_file_with_grains_data
		tests/pytests/functional/states/file/test_managed.py::test_managed_latin1_diff
		tests/pytests/functional/states/file/test_managed.py::test_managed_source_hash_indifferent_case
		tests/pytests/functional/states/file/test_managed.py::test_managed_unicode_jinja_with_tojson_filter
		tests/pytests/functional/states/file/test_recurse.py::test_issue_2726_mode_kwarg
		tests/pytests/functional/states/file/test_replace.py::test_file_replace_check_cmd
		tests/pytests/functional/states/file/test_replace.py::test_file_replace_prerequired_issues_55775
		tests/pytests/functional/states/test_pip_state.py::test_22359_pip_installed_unless_does_not_trigger_warnings
		tests/pytests/functional/states/test_pip_state.py::test_issue_2028_pip_installed_state
		tests/pytests/functional/states/test_pip_state.py::test_issue_54755
		tests/pytests/functional/states/test_pip_state.py::test_pip_installed_errors
		tests/pytests/functional/states/test_pip_state.py::test_pip_installed_removed
		tests/pytests/functional/states/test_pip_state.py::test_pip_installed_removed_venv
		tests/pytests/functional/states/test_pip_state.py::test_pip_installed_specific_env
		tests/pytests/functional/states/test_x509_v2.py::"test_private_key_managed_passphrase_changed_not_overwrite[existing_pk0]"
		tests/pytests/functional/utils/functools/test_namespaced_function.py::test_namespacing
		tests/pytests/functional/utils/test_pillar.py::test_gitpython_env
		tests/pytests/functional/utils/test_pillar.py::test_gitpython_fetch_request
		tests/pytests/functional/utils/test_pillar.py::test_gitpython_multiple_repos
		tests/pytests/functional/utils/test_pillar.py::test_pygit2_env
		tests/pytests/functional/utils/test_pillar.py::test_pygit2_multiple_repos
		tests/pytests/functional/utils/test_winrepo.py::test_gitpython_winrepo_simple
		tests/pytests/functional/utils/test_winrepo.py::test_pygit2_winrepo_simple
		tests/pytests/integration/minion/test_return_retries.py::test_pillar_timeout
		tests/pytests/integration/minion/test_return_retries.py::test_publish_retry
		tests/pytests/integration/modules/saltutil/test_pillar.py::"test_pillar_refresh[False]"
		tests/pytests/integration/modules/saltutil/test_pillar.py::"test_pillar_refresh[True]"
		tests/pytests/integration/modules/test_state.py::test_logging_and_state_output_order
		tests/pytests/integration/modules/test_test.py::test_deprecation_warning_emits_deprecation_warnings
		tests/pytests/integration/renderers/test_jinja.py::test_issue_54765_call
		tests/pytests/integration/renderers/test_jinja.py::test_issue_54765_salt
		tests/pytests/integration/ssh/state/test_pillar_override_template.py::"test_it[args0-kwargs0]"
		tests/pytests/integration/ssh/state/test_pillar_override_template.py::"test_it[args1-kwargs1]"
		tests/pytests/integration/ssh/state/test_pillar_override_template.py::"test_it[args2-kwargs2]"
		tests/pytests/integration/ssh/state/test_retcode_highstate_verification_structure_fail.py::"test_it[args0-20]"
		tests/pytests/integration/ssh/state/test_retcode_highstate_verification_structure_fail.py::"test_it[args1-20]"
		tests/pytests/integration/ssh/state/test_retcode_highstate_verification_structure_fail.py::"test_it[args2-20]"
		tests/pytests/integration/ssh/state/test_retcode_highstate_verification_structure_fail.py::"test_it[args3-20]"
		tests/pytests/integration/ssh/state/test_retcode_highstate_verification_structure_fail.py::"test_it[args4-0]"
		tests/pytests/integration/ssh/state/test_retcode_highstate_verification_structure_fail.py::"test_it[args5-20]"
		tests/pytests/integration/ssh/test_jinja_filters.py::test_dateutils_strftime
		tests/pytests/integration/ssh/test_terraform.py::test_terraform_roster
		tests/pytests/unit/config/schemas/test_ssh.py::test_config_validate
		tests/pytests/unit/grains/test_core.py::test_get_machine_id
		tests/pytests/unit/grains/test_package.py::test_grain_package_type
		tests/pytests/unit/loader/test_loader.py::test_named_loader_context_name_not_packed
		tests/pytests/unit/modules/test_beacons.py::test_add
		tests/pytests/unit/modules/test_beacons.py::test_add_beacon_module
		tests/pytests/unit/modules/test_beacons.py::test_delete
		tests/pytests/unit/modules/test_beacons.py::test_delete_beacon_module
		tests/pytests/unit/modules/test_beacons.py::test_disable
		tests/pytests/unit/modules/test_beacons.py::test_enable
		tests/pytests/unit/modules/test_beacons.py::test_enable_beacon_module
		tests/pytests/unit/modules/test_beacons.py::test_save
		tests/pytests/unit/modules/test_gpg.py::test_create_key_with_passphrase_with_gpg_passphrase_in_pillar
		tests/pytests/unit/modules/test_gpg.py::test_create_key_without_passphrase
		tests/pytests/unit/modules/test_saltutil.py::test_clear_job_cache
		tests/pytests/unit/modules/test_saltutil.py::test_list_extmods
		tests/pytests/unit/pillar/test_pillar.py::test_pillar_get_cache_disk
		tests/pytests/unit/state/test_state_compiler.py::test_verify_high_too_many_functions_declared_error_message
		tests/pytests/unit/states/test_pkg.py::test_mod_beacon
		tests/pytests/unit/states/test_service.py::test_mod_beacon
		tests/pytests/unit/test_ext_importers.py::test_tornado_import_override
		tests/pytests/unit/utils/test_rsax931.py::test_find_libcrypto_darwin_catalina
		tests/pytests/unit/utils/test_versions.py::test_warn_until_good_version_argument
		tests/unit/transport/test_ipc.py::IPCMessagePubSubCase::test_async_reading_streamclosederror
		tests/unit/utils/test_thin.py::SSHThinTestCase::test_thin_dir
		tests/unit/utils/test_vt.py::VTTestCase::test_split_multibyte_characters_shiftjis
		tests/unit/utils/test_vt.py::VTTestCase::test_split_multibyte_characters_unicode
		tests/unit/utils/test_vt.py::VTTestCase::test_vt_size

		# tests that need network access
		tests/pytests/functional/states/file/test_managed.py::test_verify_ssl_https_source
		tests/pytests/unit/modules/test_aptpkg.py::test_sourceslist_architectures
		tests/pytests/unit/modules/test_aptpkg.py::test_sourceslist_multiple_comps
		tests/pytests/unit/modules/test_yumpkg.py::test_get_yum_config
		tests/pytests/unit/modules/test_yumpkg.py::test_get_yum_config_value_none
		tests/pytests/unit/test_ext_importers.py::test_tornado_import_override
		tests/pytests/unit/utils/test_http.py::test_backends_decode_body_false
		tests/pytests/unit/utils/test_http.py::test_backends_decode_body_true
		tests/pytests/unit/utils/test_http.py::test_query_proxy
		tests/pytests/unit/utils/test_network.py::test_isportopen

		# tests that need root access
		tests/unit/modules/test_saltcheck.py::SaltcheckTestCase::test_call_salt_command
		tests/unit/modules/test_saltcheck.py::SaltcheckTestCase::test_call_salt_command2
		tests/unit/modules/test_saltcheck.py::SaltcheckTestCase::test_run_test_1
	)
	[[ ${EPYTHON#*.} -ge 11 ]] && EPYTEST_DESELECT+=(
		tests/unit/test_master.py::TransportMethodsTest::test_aes_funcs_black
		tests/unit/test_master.py::TransportMethodsTest::test_clear_funcs_black
	)
	[[ ${EPYTHON#*.} -ge 12 ]] && EPYTEST_DESELECT+=(
		tests/integration/modules/test_mine.py::MineTest::test_get_allow_tgt
		tests/integration/modules/test_mine.py::MineTest::test_mine_delete
		tests/integration/modules/test_mine.py::MineTest::test_send_allow_tgt
		tests/integration/modules/test_mine.py::MineTest::test_send_allow_tgt_compound
		tests/integration/modules/test_saltcheck.py::SaltcheckModuleTest::test_saltcheck_checkall
		tests/integration/modules/test_saltcheck.py::SaltcheckModuleTest::test_saltcheck_checkall_saltenv
		tests/integration/modules/test_saltcheck.py::SaltcheckModuleTest::test_saltcheck_run
		tests/integration/modules/test_saltcheck.py::SaltcheckModuleTest::test_saltcheck_saltenv
		tests/integration/modules/test_saltcheck.py::SaltcheckModuleTest::test_saltcheck_state
		tests/integration/output/test_output.py::OutputReturnTest::test_output_highstate
		tests/integration/output/test_output.py::OutputReturnTest::test_output_json
		tests/integration/output/test_output.py::OutputReturnTest::test_output_nested
		tests/integration/output/test_output.py::OutputReturnTest::test_output_pprint
		tests/integration/output/test_output.py::OutputReturnTest::test_output_raw
		tests/integration/output/test_output.py::OutputReturnTest::test_output_txt
		tests/integration/output/test_output.py::OutputReturnTest::test_output_yaml
		tests/integration/output/test_output.py::OutputReturnTest::test_output_yaml_namespaced_dict_wrapper
		tests/integration/output/test_output.py::OutputReturnTest::test_static_simple
		tests/integration/runners/test_manage.py::ManageTest::test_down
		tests/integration/runners/test_manage.py::ManageTest::test_up
		tests/integration/shell/test_master_tops.py::MasterTopsTest::test_custom_tops_gets_utilized
		tests/integration/states/test_archive.py::ArchiveTest::test_local_archive_extracted_with_skip_files_list_verify_and_keep_source_is_false
		tests/pytests/functional/states/test_pip_state.py::test_issue_2087_missing_pip
		tests/pytests/unit/modules/test_nilrt_ip.py::"test_when_default_value_is_not_a_string_and_option_is_missing_the_default_value_should_be_returned[-99.9]"
		tests/pytests/unit/modules/test_nilrt_ip.py::"test_when_default_value_is_not_a_string_and_option_is_missing_the_default_value_should_be_returned[42]"
		tests/pytests/unit/modules/test_nilrt_ip.py::"test_when_default_value_is_not_a_string_and_option_is_missing_the_default_value_should_be_returned[default_value2]"
		tests/pytests/unit/modules/test_nilrt_ip.py::"test_when_default_value_is_not_a_string_and_option_is_missing_the_default_value_should_be_returned[default_value3]"
		tests/pytests/unit/modules/test_nilrt_ip.py::"test_when_default_value_is_not_a_string_and_option_is_missing_the_default_value_should_be_returned[default_value4]"
		tests/pytests/unit/modules/test_nilrt_ip.py::test_when_config_has_no_quotes_around_string_it_should_be_returned_as_is
		tests/pytests/unit/modules/test_nilrt_ip.py::test_when_config_has_quotes_around_string_they_should_be_removed
		tests/pytests/unit/utils/vault/test_auth.py::"test_approle_auth_get_token_login[secret_id-approle]"
		tests/unit/modules/test_zypperpkg.py::ZypperTestCase::test_repo_value_info
		tests/unit/utils/test_color.py::ColorUtilsTestCase::test_get_colors
	)

	# testsuite likes lots of files
	ulimit -n 4096 || die

	# ${T} is too long a path for the tests to work
	local TMPDIR
	TMPDIR="$(mktemp --directory --tmpdir=/tmp ${PN}-XXXX)" || die
	(
		test_exports=(
			TMPDIR
			SHELL="/bin/bash"
			USE_SETUPTOOLS=1
			NO_INTERNET=1
			PYTHONDONTWRITEBYTECODE=1
		)
		export "${test_exports[@]}"

		cleanup() { rm -rf "${TMPDIR}" || die; }

		trap cleanup EXIT

		addwrite "${TMPDIR}"

		epytest --run-slow
	)
}
