# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_7 )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit systemd distutils-r1

DESCRIPTION="Salt is a remote execution and configuration manager"
HOMEPAGE="https://www.saltstack.com/resources/community/
	https://github.com/saltstack"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/${PN}stack/${PN}.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="cheetah cherrypy ldap libcloud libvirt genshi gnupg keyring mako
	mongodb neutron	nova openssl portage profile redis selinux test raet
	+zeromq vim-syntax"

RDEPEND="
	sys-apps/pciutils
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/libnacl[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.5[${PYTHON_USEDEP}]
	<dev-python/msgpack-1.0[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	>=dev-python/requests-1.0.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	libcloud? ( >=dev-python/libcloud-0.14.0[${PYTHON_USEDEP}] )
	mako? ( dev-python/mako[${PYTHON_USEDEP}] )
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )
	libvirt? (
		$(python_gen_cond_dep 'dev-python/libvirt-python[${PYTHON_USEDEP}]' python3_7)
	)
	openssl? (
		dev-libs/openssl:0=[-bindist]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	)
	raet? (
		>=dev-python/libnacl-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/ioflo-1.1.7[${PYTHON_USEDEP}]
		>=dev-python/raet-0.6.0[${PYTHON_USEDEP}]
	)
	cherrypy? ( >=dev-python/cherrypy-3.2.2[${PYTHON_USEDEP}] )
	cheetah? ( dev-python/cheetah3[${PYTHON_USEDEP}] )
	mongodb? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	portage? ( sys-apps/portage[${PYTHON_USEDEP}] )
	keyring? ( dev-python/keyring[${PYTHON_USEDEP}] )
	redis? ( dev-python/redis-py[${PYTHON_USEDEP}] )
	selinux? ( sec-policy/selinux-salt )
	nova? (
		$(python_gen_cond_dep '>=dev-python/python-novaclient-2.17.0[${PYTHON_USEDEP}]' python3_7)
	)
	neutron? (
		$(python_gen_cond_dep '>=dev-python/python-neutronclient-2.3.6[${PYTHON_USEDEP}]' python3_7)
	)
	gnupg? ( dev-python/python-gnupg[${PYTHON_USEDEP}] )
	profile? ( dev-python/yappi[${PYTHON_USEDEP}] )
	vim-syntax? ( app-vim/salt-vim )
	zeromq? ( >=dev-python/pyzmq-2.2.0[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		${RDEPEND}
		>=dev-python/boto-2.32.1[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]
		>=dev-python/libcloud-0.14.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/moto-0.3.6[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
		dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
		>=dev-python/pytest-salt-2018.12.8[${PYTHON_USEDEP}]
		dev-python/pytest-tempdir[${PYTHON_USEDEP}]
		>=dev-python/SaltTesting-2016.5.11[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		!x86? ( >=dev-python/boto3-1.2.1[${PYTHON_USEDEP}] )
	)"

DOCS=( README.rst AUTHORS )

REQUIRED_USE="|| ( raet zeromq )
	test? ( cheetah genshi )"
RESTRICT="!test? ( test ) x86? ( test )"

PATCHES=(
	"${FILESDIR}/salt-2017.7.0-dont-realpath-tmpdir.patch"
	"${FILESDIR}/salt-2019.2.0-skip-tests-that-oom-machine.patch"
	"${FILESDIR}/salt-3000.1-tests.patch"
)

python_prepare() {
	# remove tests with external dependencies that may not be available
	rm tests/unit/{test_zypp_plugins.py,utils/test_extend.py} || die
	rm tests/unit/modules/test_{file,boto_{vpc,secgroup,elb}}.py || die
	rm tests/unit/states/test_boto_vpc.py || die

	# tests that require network access
	rm tests/unit/{states,modules}/test_zcbuildout.py || die

	# allow the use of the renamed msgpack
	sed -i '/^msgpack/d' requirements/base.txt || die
}

python_install_all() {
	local svc
	USE_SETUPTOOLS=1 distutils-r1_python_install_all

	for svc in minion master syndic api; do
		newinitd "${FILESDIR}"/${svc}-initd-4 salt-${svc}
		newconfd "${FILESDIR}"/${svc}-confd-1 salt-${svc}
		systemd_dounit "${FILESDIR}"/salt-${svc}.service
	done

	insinto /etc/${PN}
	doins -r conf/*
}

python_test() {
	local tempdir
	# testsuite likes lots of files
	ulimit -n 3072 || die

	# ${T} is too long a path for the tests to work
	tempdir="$(mktemp -du --tmpdir=/tmp salt-XXX)"
	mkdir "${T}/$(basename "${tempdir}")"

	(
		cleanup() { rm -f "${tempdir}" || die; }

		trap cleanup EXIT

		addwrite "${tempdir}"
		ln -s "$(realpath --relative-to=/tmp "${T}/$(basename "${tempdir}")")" "${tempdir}" || die

		USE_SETUPTOOLS=1 SHELL="/bin/bash" \
			TMPDIR="${tempdir}" \
			${EPYTHON} tests/runtests.py \
			--unit-tests --no-report --verbose \
			|| die "testing failed with ${EPYTHON}"
	)
}

pkg_postinst_disabled() {
	if use python_targets_python3_8; then
		if use nova; then
			ewarn "Salt's nova functionality will not work with python3.8 since"
			ewarn "dev-python/python-novaclient does not support it yet"
		fi
		if use neutron; then
			ewarn "Salt's neutron functionality will not work with python3.8 since"
			ewarn "dev-python/python-neutronclient does not support it yet"
		fi
		if use libvirt; then
			ewarn "Salt's libvirt functionality will not work with python3.8 since"
			ewarn "dev-python/libvirt-python does not support it yet"
		fi
	fi
}
