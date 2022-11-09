# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

DISTUTILS_USE_PEP517=setuptools
inherit systemd distutils-r1

DESCRIPTION="Salt is a remote execution and configuration manager"
HOMEPAGE="https://www.saltstack.com/resources/community/
	https://github.com/saltstack"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}stack/${PN}.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
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
	>=dev-python/jinja-3.0.3[${PYTHON_USEDEP}]
	dev-python/jmespath[${PYTHON_USEDEP}]
	dev-python/libnacl[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.9.8[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/requests-1.0.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	libcloud? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/aiosignal[${PYTHON_USEDEP}]
		dev-python/async-timeout[${PYTHON_USEDEP}]
		>=dev-python/libcloud-2.5.0[${PYTHON_USEDEP}]
	)
	mako? ( dev-python/mako[${PYTHON_USEDEP}] )
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )
	libvirt? (
		dev-python/libvirt-python[${PYTHON_USEDEP}]
	)
	openssl? (
		dev-libs/openssl:0=[-bindist(-)]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
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
	redis? ( dev-python/redis-py[${PYTHON_USEDEP}] )
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
		>=dev-python/boto-2.32.1[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/cherrypy[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]
		dev-python/mako[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/moto-2.0.0[${PYTHON_USEDEP}]
		dev-python/passlib
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-salt-factories-1.0.0_rc17[${PYTHON_USEDEP}]
		dev-python/pytest-tempdir[${PYTHON_USEDEP}]
		dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
		dev-python/pytest-shell-utilities[${PYTHON_USEDEP}]
		dev-python/pytest-skip-markers[${PYTHON_USEDEP}]
		dev-python/pytest-system-statistics[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/libcloud[${PYTHON_USEDEP}]
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
	"${FILESDIR}/salt-3003-skip-tests-that-oom-machine.patch"
	"${FILESDIR}/salt-3003-gentoolkit-revdep.patch"
	"${FILESDIR}/salt-3002-tests.patch"
	"${FILESDIR}/salt-3003.1-tests.patch"
	"${FILESDIR}/salt-3005-relax-pyzmq-dep.patch"
	"${FILESDIR}/salt-3005-tests.patch"
	"${FILESDIR}/salt-3005.1-no-entry-points.patch"
	"${FILESDIR}/salt-3005.1-importlib-metadata-5.patch"
	"${FILESDIR}/salt-3005.1-tests.patch"
)

python_prepare_all() {
	# remove tests with external dependencies that may not be available, and
	# tests that don't work in sandbox
	rm tests/unit/{test_{zypp_plugins,module_names},utils/test_extend}.py || die
	rm tests/unit/modules/test_boto_{vpc,secgroup,elb}.py || die
	rm tests/unit/states/test_boto_vpc.py || die
	rm tests/support/gitfs.py tests/unit/runners/test_git_pillar.py || die
	rm tests/pytests/functional/transport/server/test_req_channel.py || die
	rm tests/pytests/functional/utils/test_async_event_publisher.py || die
	rm tests/pytests/functional/runners/test_winrepo.py || die

	# tests that require network access
	rm tests/unit/{states,modules}/test_zcbuildout.py || die
	rm -r tests/integration/cloud || die
	rm -r tests/kitchen/tests/wordpress/tests || die
	rm tests/kitchen/test_kitchen.py || die
	rm tests/unit/modules/test_network.py || die
	rm tests/pytests/functional/modules/test_pip.py || die
	rm tests/pytests/unit/client/ssh/test_ssh.py || die
	rm -r tests/pytests/{integration,functional}/netapi tests/integration/netapi || die

	# tests require root access
	rm tests/integration/pillar/test_git_pillar.py || die
	rm tests/integration/states/test_supervisord.py || die

	# removes contextvars, see bug: https://bugs.gentoo.org/799431
	sed -i '/^contextvars/d' requirements/base.txt || die

	# make sure pkg_resources doesn't bomb because pycrypto isn't installed
	find "${S}" -name '*.txt' -print0 | xargs -0 sed -e '/pycrypto>/ d ; /pycryptodomex/ d' -i || die
	# pycryptodome rather than pycryptodomex
	find "${S}" -name '*.py' -print0 | xargs -0 -- sed -i -e 's:Cryptodome:Crypto:g' -- || die

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
	# testsuite likes lots of files
	ulimit -n 4096 || die

	local -a disable_tests=(
		# doesn't like the distutils warning
		batch_retcode
		multiple_modules_in_batch
		# hangs indefinitely
		master_type_disable
		# needs root
		runas_env_sudo_group
		# don't like sandbox
		split_multibyte_characters_{shiftjis,unicode}
		# doesn't like sandbox env
		log_sanitize
	)
	local textexpr
	testexpr=$(printf 'not %s and ' "${disable_tests[@]}")

	# ${T} is too long a path for the tests to work
	local TMPDIR
	TMPDIR="$(mktemp --directory --tmpdir=/tmp ${PN}-XXXX)" || die
	(
		export TMPDIR
		cleanup() { rm -rf "${TMPDIR}" || die; }

		trap cleanup EXIT

		addwrite "${TMPDIR}"

		USE_SETUPTOOLS=1 NO_INTERNET=1 SHELL="/bin/bash" \
			"${EPYTHON}" -m pytest -vv -k "${testexpr%and }" \
			|| die "testing failed with ${EPYTHON}"
	)
}
