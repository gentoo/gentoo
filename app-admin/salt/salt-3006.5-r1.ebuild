# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_10 )

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
	mongodb neutron	nova openssl portage profile redis selinux test raet
	+zeromq vim-syntax
"

RDEPEND="
	sys-apps/pciutils
	>=dev-python/cryptography-41.0.3[${PYTHON_USEDEP}]
	>=dev-python/distro-1.5[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.1.2[${PYTHON_USEDEP}]
	dev-python/jmespath[${PYTHON_USEDEP}]
	dev-python/libnacl[${PYTHON_USEDEP}]
	dev-python/looseversion[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.9.8[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.1[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.1.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	libcloud? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/aiosignal[${PYTHON_USEDEP}]
		>=dev-python/apache-libcloud-2.5.0[${PYTHON_USEDEP}]
		dev-python/async-timeout[${PYTHON_USEDEP}]
	)
	mako? ( dev-python/mako[${PYTHON_USEDEP}] )
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )
	libvirt? (
		dev-python/libvirt-python[${PYTHON_USEDEP}]
	)
	openssl? (
		dev-libs/openssl:0=[-bindist(-)]
		>=dev-python/pyopenssl-23.2.0[${PYTHON_USEDEP}]
	)
	raet? (
		>=dev-python/libnacl-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/ioflo-1.1.7[${PYTHON_USEDEP}]
		>=dev-python/raet-0.6.0[${PYTHON_USEDEP}]
	)
	cherrypy? ( >=dev-python/cherrypy-3.2.2[${PYTHON_USEDEP}] )
	cheetah? ( >=dev-python/cheetah3-3.2.2[${PYTHON_USEDEP}] )
	genshi? ( dev-python/genshi[${PYTHON_USEDEP}] )
	mongodb? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	portage? ( sys-apps/portage[${PYTHON_USEDEP}] )
	keyring? ( dev-python/keyring[${PYTHON_USEDEP}] )
	redis? ( dev-python/redis[${PYTHON_USEDEP}] )
	selinux? ( sec-policy/selinux-salt )
	nova? (
		>=dev-python/python-novaclient-2.17.0[${PYTHON_USEDEP}]
	)
	neutron? (
		>=dev-python/python-neutronclient-2.3.6[${PYTHON_USEDEP}]
	)
	gnupg? ( dev-python/python-gnupg[${PYTHON_USEDEP}] )
	profile? ( dev-python/yappi[${PYTHON_USEDEP}] )
	vim-syntax? ( app-vim/salt-vim )
	zeromq? ( >=dev-python/pyzmq-19.0.0[${PYTHON_USEDEP}] )
"
BDEPEND="
	dev-python/build[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/apache-libcloud[${PYTHON_USEDEP}]
		dev-python/boto3[${PYTHON_USEDEP}]
		>=dev-python/certifi-2023.07.22[${PYTHON_USEDEP}]
		dev-python/cherrypy[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]
		dev-python/mako[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/moto-2.0.0[${PYTHON_USEDEP}]
		dev-python/passlib[${PYTHON_USEDEP}]
		dev-python/bcrypt[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-23.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-salt-factories-1.0.0_rc28[${PYTHON_USEDEP}]
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

REQUIRED_USE="|| ( raet zeromq )
	test? ( cheetah genshi )"
RESTRICT="!test? ( test ) x86? ( test )"

PATCHES=(
	"${FILESDIR}/salt-3003-gentoolkit-revdep.patch"
	"${FILESDIR}/salt-3005.1-no-entry-points.patch"
)

python_prepare_all() {
	local -a remove_test_files=(
		# remove tests with external dependencies that may not be available, and
		# tests that don't work in sandbox
		tests/pytests/functional/modules/file/test_readlink.py
		tests/pytests/functional/modules/file/test_symlink.py
		tests/pytests/functional/modules/state/test_jinja_filters.py
		tests/pytests/functional/modules/state/test_jinja_renderer.py
		tests/pytests/functional/modules/state/test_mako_renderer.py
		tests/pytests/functional/modules/state/test_pyobjects_renderer.py
		tests/pytests/functional/pillar/test_gpg.py
		tests/pytests/functional/runners/test_winrepo.py
		tests/pytests/functional/states/file/test_keyvalue.py
		tests/pytests/functional/states/file/test_patch.py
		tests/pytests/functional/transport/server/test_req_channel.py
		tests/pytests/functional/utils/test_async_event_publisher.py
		tests/pytests/integration/master/test_clear_funcs.py
		tests/pytests/integration/minion/test_reauth.py
		tests/pytests/integration/returners/test_noop_return.py
		tests/pytests/integration/runners/test_manage.py
		tests/pytests/integration/states/test_ini_manage.py
		tests/pytests/integration/states/test_state_test.py
		tests/pytests/integration/utils/test_templates.py
		tests/pytests/unit/loader/test_lazy.py
		tests/pytests/unit/modules/test_aptpkg.py
		tests/pytests/unit/roster/test_dir.py
		tests/pytests/unit/states/file/test_keyvalue.py
		tests/pytests/unit/utils/jinja/test_get_template.py
		tests/pytests/unit/utils/jinja/test_salt_cache_loader.py
		tests/unit/modules/test_boto_{vpc,secgroup,elb}.py
		tests/unit/netapi/rest_tornado/test_saltnado.py
		tests/unit/{test_{zypp_plugins,module_names},utils/test_extend}.py

		# tests that require network access
		tests/integration/cloud
		tests/integration/netapi
		tests/kitchen/test_kitchen.py
		tests/kitchen/tests/wordpress/tests
		tests/pytests/functional/cli/test_salt_cloud.py
		tests/pytests/functional/cli/test_salt_run_.py
		tests/pytests/functional/modules/test_http.py
		tests/pytests/functional/modules/test_pip.py
		tests/pytests/integration/cli/test_salt_proxy.py
		tests/pytests/integration/modules/state/test_state.py
		tests/pytests/integration/modules/state/test_state_state_events.py
		tests/pytests/integration/modules/test_jinja.py
		tests/pytests/integration/modules/test_state.py
		tests/pytests/integration/modules/test_test.py
		tests/pytests/integration/pillar/cache/test_pillar_cache.py
		tests/pytests/integration/pillar/test_pillar_include.py
		tests/pytests/integration/proxy/test_simple.py
		tests/pytests/integration/runners/state/orchestrate/test_events.py
		tests/pytests/integration/wheel/test_pillar_roots.py
		tests/pytests/unit/client/ssh/test_ssh.py
		tests/pytests/unit/test_client.py
		tests/pytests/{integration,functional}/netapi
		tests/unit/modules/test_boto3_elasticsearch.py
		tests/unit/modules/test_boto3_route53.py
		tests/unit/modules/test_network.py
		tests/unit/{states,modules}/test_zcbuildout.py

		# tests require root access
		tests/integration/pillar/test_git_pillar.py
		tests/integration/states/test_supervisord.py
		tests/pytests/functional/states/file/test_accumulated.py
		tests/pytests/scenarios/performance/test_performance.py
		tests/pytests/unit/cloud/test_map.py
		tests/pytests/unit/modules/state/test_state.py
		tests/pytests/unit/modules/state/test_top_file_merge.py
		tests/pytests/unit/proxy/test_netmiko_px.py
		tests/pytests/unit/proxy/test_ssh_sample.py
		tests/pytests/unit/roster/test_sshknownhosts.py
	)

	rm -r "${remove_test_files[@]}" || die

	# axe the boto dep (bug #888235)
	find "${S}/tests" -name 'test_boto_*.py' -delete || die

	# removes contextvars, see bug: https://bugs.gentoo.org/799431
	sed -i '/^contextvars/d' requirements/base.txt || die

	# make sure pkg_resources doesn't bomb because pycrypto isn't installed
	find "${S}" -name '*.txt' -print0 | xargs -0 sed -e '/pycrypto>/ d ; /pycryptodomex/ d' -i || die
	# pycryptodome rather than pycryptodomex
	find "${S}" -name '*.py' -print0 | xargs -0 -- sed -i -e 's:Cryptodome:Crypto:g' -- || die

	# called_once should be assert_called_once_with
	find "${S}/tests" -name '*.py' -print0 | xargs -0 -- sed -i -e 's:[.]called_once:.assert_called_once:g' -- || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	local svc
	USE_SETUPTOOLS=1 distutils-r1_python_install_all

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
		tests/pytests/integration/modules/test_cmdmod.py::test_long_stdout

		# don't like sandbox
		tests/pytests/functional/cli/test_salt.py::test_help_log
		tests/pytests/functional/cli/test_salt.py::test_versions_report
		tests/pytests/functional/fileserver/test_roots.py::test_symlink_list
		tests/pytests/functional/modules/file/test_replace.py::test_append_if_not_found_content
		tests/pytests/functional/modules/file/test_replace.py::test_append_if_not_found_empty_file
		tests/pytests/functional/modules/file/test_replace.py::test_append_if_not_found_no_append_on_match
		tests/pytests/functional/modules/file/test_replace.py::test_append_if_not_found_no_match_newline
		tests/pytests/functional/modules/file/test_replace.py::test_append_if_not_found_no_match_no_newline
		tests/pytests/functional/modules/test_defaults.py::test_defaults_get
		tests/pytests/functional/pillar/test_top.py::test_pillar_top_compound_match
		tests/pytests/functional/states/file/test_append.py::test_file_append_check_cmd
		tests/pytests/functional/states/file/test_blockreplace.py::test_issue_49043
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
		tests/pytests/functional/states/file/test_managed.py::test_verify_ssl_https_source[False]
		tests/pytests/functional/states/file/test_managed.py::test_verify_ssl_https_source[True]
		tests/pytests/functional/states/file/test_recurse.py::test_issue_2726_mode_kwarg
		tests/pytests/functional/states/file/test_replace.py::test_file_replace_check_cmd
		tests/pytests/functional/states/file/test_replace.py::test_file_replace_prerequired_issues_55775
		tests/pytests/functional/utils/functools/test_namespaced_function.py::test_namespacing
		tests/pytests/integration/ssh/test_pillar_compilation.py::test_gpg_pillar
		tests/pytests/integration/ssh/test_pillar_compilation.py::test_saltutil_runner
		tests/pytests/unit/_logging/handlers/test_deferred_stream_handler.py::test_deferred_write_on_flush
		tests/pytests/unit/_logging/handlers/test_deferred_stream_handler.py::test_sync_with_handlers
		tests/pytests/unit/client/ssh/test_single.py::test_run_with_pre_flight_args
		tests/pytests/unit/config/schemas/test_ssh.py::test_config_validate
		tests/pytests/unit/modules/test_aptpkg.py::test_call_apt_dpkg_lock
		tests/pytests/unit/modules/test_msteams.py::test_post_card
		tests/pytests/unit/modules/test_portage_config.py::test_enforce_nice_config
		tests/pytests/unit/modules/test_saltutil.py::test_clear_job_cache
		tests/pytests/unit/modules/test_saltutil.py::test_list_extmods
		tests/pytests/unit/modules/test_yumpkg.py::test_get_yum_config
		tests/pytests/unit/pillar/test_pillar.py::test_pillar_get_cache_disk
		tests/pytests/unit/renderers/test_yamlex.py::test_basic
		tests/pytests/unit/renderers/test_yamlex.py::test_complex
		tests/pytests/unit/states/test_file.py::test_file_recurse_directory_test
		tests/pytests/unit/test_ext_importers.py::test_tornado_import_override
		tests/pytests/unit/test_master.py::test_fileserver_duration
		tests/pytests/unit/test_template.py::test_compile_template_str_mkstemp_cleanup
		tests/pytests/unit/utils/test_cache.py::test_context_wrapper
		tests/pytests/unit/utils/test_cache.py::test_refill_cache
		tests/pytests/unit/utils/test_cache.py::test_set_cache
		tests/pytests/unit/utils/test_http.py::test_requests_session_verify_ssl_false
		tests/pytests/unit/utils/test_vt.py::test_log_sanitize
		tests/unit/utils/test_schema.py::ConfigTestCase::test_anyof_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_array_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_array_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_dict_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_hostname_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_not_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_oneof_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_optional_requirements_config_validation
		tests/unit/utils/test_vt.py::test_split_multibyte_characters_shiftjis
		tests/unit/utils/test_vt.py::test_split_multibyte_characters_unicode

		# tests that need network access
		tests/pytests/unit/utils/test_http.py::test_query_proxy
		tests/pytests/unit/utils/test_http.py::test_backends_decode_body_false
		tests/pytests/unit/utils/test_http.py::test_backends_decode_body_true
		tests/pytests/unit/utils/test_network.py::test_isportopen
	)

	# testsuite likes lots of files
	ulimit -n 4096 || die

	# ${T} is too long a path for the tests to work
	local TMPDIR
	TMPDIR="$(mktemp --directory --tmpdir=/tmp ${PN}-XXXX)" || die
	(
		export TMPDIR
		cleanup() { rm -rf "${TMPDIR}" || die; }

		trap cleanup EXIT

		addwrite "${TMPDIR}"

		USE_SETUPTOOLS=1 NO_INTERNET=1 SHELL="/bin/bash" \
			epytest
	)
}
