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
	KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"
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
	>=dev-python/distro-1.5[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.1.2[${PYTHON_USEDEP}]
	dev-python/jmespath[${PYTHON_USEDEP}]
	dev-python/libnacl[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.0.0[${PYTHON_USEDEP}]
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
	test? (
		${RDEPEND}
		dev-python/apache-libcloud[${PYTHON_USEDEP}]
		>=dev-python/certifi-2023.07.22[${PYTHON_USEDEP}]
		dev-python/cherrypy[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]
		dev-python/mako[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/moto-2.0.0[${PYTHON_USEDEP}]
		dev-python/passlib[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-23.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-salt-factories-1.0.0_rc17[${PYTHON_USEDEP}]
		dev-python/pytest-tempdir[${PYTHON_USEDEP}]
		dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
		dev-python/pytest-shell-utilities[${PYTHON_USEDEP}]
		dev-python/pytest-skip-markers[${PYTHON_USEDEP}]
		dev-python/pytest-system-statistics[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		net-dns/bind-tools
		>=dev-python/virtualenv-20.3.0[${PYTHON_USEDEP}]
		dev-util/yamllint[${PYTHON_USEDEP}]
		!x86? ( >=dev-python/boto3-1.17.67[${PYTHON_USEDEP}] )
	)
"

DOCS=( README.rst AUTHORS )

REQUIRED_USE="|| ( raet zeromq )
	test? ( cheetah genshi )"
RESTRICT="!test? ( test ) x86? ( test )"

PATCHES=(
	"${FILESDIR}/salt-3003-gentoolkit-revdep.patch"
	"${FILESDIR}/salt-3002-tests.patch"
	"${FILESDIR}/salt-3003.1-tests.patch"
	"${FILESDIR}/salt-3005-tests.patch"
	"${FILESDIR}/salt-3005.1-no-entry-points.patch"
	"${FILESDIR}/salt-3005.1-importlib-metadata-5-r1.patch"
	"${FILESDIR}/salt-3005.1-tests.patch"
	"${FILESDIR}/salt-3005.1-modules-file-python-3.11-host.patch"
	"${FILESDIR}/salt-3006.2-tests.patch"
)

python_prepare_all() {
	local -a remove_test_files=(
		# remove tests with external dependencies that may not be available, and
		# tests that don't work in sandbox
		tests/pytests/functional/fileserver/test_roots.py
		tests/pytests/functional/modules/file/test_readlink.py
		tests/pytests/functional/modules/file/test_replace.py
		tests/pytests/functional/modules/file/test_symlink.py
		tests/pytests/functional/modules/state/requisites/test_mixed.py
		tests/pytests/functional/modules/state/test_jinja_renderer.py
		tests/pytests/functional/modules/state/test_state.py
		tests/pytests/functional/pillar/test_top.py
		tests/pytests/functional/runners/test_winrepo.py
		tests/pytests/functional/transport/server/test_req_channel.py
		tests/pytests/functional/utils/functools/test_namespaced_function.py
		tests/pytests/functional/utils/test_async_event_publisher.py
		tests/pytests/integration/modules/state/test_state.py
		tests/pytests/integration/pillar/cache/test_pillar_cache.py
		tests/pytests/integration/pillar/test_pillar_include.py
		tests/pytests/integration/proxy/test_deltaproxy.py
		tests/pytests/integration/returners/test_noop_return.py
		tests/pytests/integration/runners/test_manage.py
		tests/pytests/integration/utils/test_templates.py
		tests/pytests/unit/loader/test_lazy.py
		tests/pytests/unit/modules/state/test_top_file_merge.py
		tests/pytests/unit/roster/test_dir.py
		tests/pytests/unit/state/test_multi_env_highstate.py
		tests/pytests/unit/state/test_state_highstate.py
		tests/pytests/unit/states/file/test_keyvalue.py
		tests/pytests/unit/utils/jinja/test_get_template.py
		tests/pytests/unit/utils/jinja/test_salt_cache_loader.py
		tests/pytests/unit/utils/test_cache.py
		tests/pytests/unit/utils/test_versions.py
		tests/support/gitfs.py
		tests/unit/modules/test_boto_{vpc,secgroup,elb}.py
		tests/unit/runners/test_git_pillar.py
		tests/unit/states/test_boto_vpc.py
		tests/unit/{test_{zypp_plugins,module_names},utils/test_extend}.py

		# tests that require network access
		tests/integration/cloud
		tests/kitchen/test_kitchen.py
		tests/kitchen/tests/wordpress/tests
		tests/pytests/functional/cli/test_salt_cloud.py
		tests/pytests/functional/modules/state/requisites/test_listen.py
		tests/pytests/functional/modules/state/requisites/test_onchanges.py
		tests/pytests/functional/modules/state/requisites/test_onfail.py
		tests/pytests/functional/modules/state/requisites/test_prereq.py
		tests/pytests/functional/modules/state/requisites/test_require.py
		tests/pytests/functional/modules/state/requisites/test_unless.py
		tests/pytests/functional/modules/state/requisites/test_use.py
		tests/pytests/functional/modules/state/requisites/test_watch.py
		tests/pytests/functional/modules/test_pip.py
		tests/pytests/functional/pillar/test_gpg.py
		tests/pytests/functional/states/file/test_comment.py
		tests/pytests/functional/states/file/test_rename.py
		tests/pytests/integration/cli/test_batch.py
		tests/pytests/integration/cli/test_salt_deltaproxy.py
		tests/pytests/integration/cli/test_salt_proxy.py
		tests/pytests/integration/master/test_clear_funcs.py
		tests/pytests/integration/modules/test_state.py
		tests/pytests/integration/proxy/test_simple.py
		tests/pytests/integration/runners/state/orchestrate/test_events.py
		tests/pytests/integration/wheel/test_pillar_roots.py
		tests/pytests/unit/client/ssh/test_ssh.py
		tests/pytests/unit/cloud/test_map.py
		tests/pytests/unit/fileserver/test_roots.py
		tests/pytests/unit/modules/state/test_state.py
		tests/pytests/unit/proxy/test_netmiko_px.py
		tests/pytests/unit/test_client.py
		tests/pytests/unit/test_ext_importers.py
		tests/pytests/unit/test_master.py
		tests/pytests/{integration,functional}/netapi tests/integration/netapi
		tests/unit/cloud/clouds/test_joyent.py
		tests/unit/config/schemas/test_ssh.py
		tests/unit/modules/test_boto3_elasticsearch.py
		tests/unit/modules/test_boto3_route53.py
		tests/unit/modules/test_network.py
		tests/unit/netapi/rest_tornado/test_saltnado.py
		tests/unit/{states,modules}/test_zcbuildout.py

		# tests require root access
		tests/integration/pillar/test_git_pillar.py
		tests/integration/states/test_supervisord.py
	)

	rm -r "${remove_test_files[@]}" || die

	# axe the boto dep (bug #888235)
	find "${S}/tests" -name 'test_boto_*.py' -delete || die

	# removes contextvars, see bug: https://bugs.gentoo.org/799431
	sed -i '/^contextvars/d' requirements/base.txt || die

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
		# hangs indefinitely
		tests/pytests/unit/test_minion.py::test_master_type_disable
		# don't like sandbox
		tests/pytests/functional/modules/test_saltutil.py::test__get_top_file_envs
		tests/pytests/functional/modules/state/requisites/test_onlyif.py::test_onlyif_req_retcode
		tests/pytests/integration/modules/test_state.py::test_logging_and_state_output_order
		tests/pytests/integration/states/test_ini_manage.py::test_options_present

		tests/pytests/functional/cli/test_salt.py::test_versions_report
		tests/pytests/unit/modules/test_aptpkg.py::test_call_apt_dpkg_lock
		tests/pytests/unit/test_master.py::test_fileserver_duration
		tests/pytests/unit/utils/test_vt.py::test_log_sanitize
		tests/unit/utils/test_schema.py::ConfigTestCase::test_anyof_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_array_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_dict_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_hostname_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_not_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_oneof_config_validation
		tests/unit/utils/test_schema.py::ConfigTestCase::test_optional_requirements_config_validation
		tests/unit/utils/test_vt.py::VTTestCase::test_split_multibyte_characters_shiftjis
		tests/unit/utils/test_vt.py::VTTestCase::test_split_multibyte_characters_unicode

		# need root
		tests/pytests/unit/modules/test_cmdmod.py::test_runas_env_sudo_group
	)

	# https://bugs.gentoo.org/924377
	has_version 'sys-apps/systemd' || EPYTEST_DESELECT+=(
		tests/pytests/unit/modules/test_aptpkg.py::test_autoremove
		tests/pytests/unit/modules/test_aptpkg.py::test_upgrade
		tests/pytests/unit/modules/test_aptpkg.py::test_upgrade_downloadonly
		tests/pytests/unit/modules/test_aptpkg.py::test_upgrade_allow_downgrades
		tests/pytests/unit/modules/test_aptpkg.py::test_call_apt_default
		tests/pytests/unit/modules/test_aptpkg.py::test_call_apt_with_kwargs
		tests/pytests/unit/modules/test_linux_sysctl.py::test_persist_no_conf_failure
		tests/pytests/unit/modules/test_yumpkg.py::test_latest_version_with_options
		tests/pytests/unit/modules/test_yumpkg.py::test_list_repo_pkgs_with_options
		tests/pytests/unit/modules/test_yumpkg.py::test_list_upgrades_dnf
		tests/pytests/unit/modules/test_yumpkg.py::test_list_upgrades_yum
		tests/pytests/unit/modules/test_yumpkg.py::test_refresh_db_with_options
		tests/pytests/unit/modules/test_yumpkg.py::test_call_yum_default
		tests/pytests/unit/modules/test_yumpkg.py::test_call_yum_with_kwargs
		tests/unit/modules/test_kernelpkg_linux_yum.py::YumKernelPkgTestCase::test_remove_error
		tests/unit/modules/test_kernelpkg_linux_yum.py::YumKernelPkgTestCase::test_remove_success
		tests/unit/modules/test_zypperpkg.py::ZypperTestCase::test_remove_purge
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
