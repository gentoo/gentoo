# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python2_7)

inherit eutils distutils-r1 systemd

DESCRIPTION="Salt is a remote execution and configuration manager"
HOMEPAGE="http://saltstack.org/"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/${PN}stack/${PN}.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="api ldap libcloud libvirt gnupg keyring mako mongodb mysql nova"
IUSE+=" openssl redis selinux timelib raet +zeromq test"

RDEPEND="sys-apps/pciutils
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.3[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	>=dev-python/requests-1.0.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	libcloud? ( >=dev-python/libcloud-0.14.0[${PYTHON_USEDEP}] )
	mako? ( dev-python/mako[${PYTHON_USEDEP}] )
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )
	openssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	libvirt? ( dev-python/libvirt-python[${PYTHON_USEDEP}] )
	raet? (
		dev-python/libnacl[${PYTHON_USEDEP}]
		dev-python/ioflo[${PYTHON_USEDEP}]
		dev-python/raet[${PYTHON_USEDEP}]
	)
	zeromq? (
		>=dev-python/pyzmq-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/m2crypto-0.22.3[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
	)
	api? (
		|| (
			dev-python/cherrypy[${PYTHON_USEDEP}]
			www-servers/tornado[${PYTHON_USEDEP}]
		)
	)
	mongodb? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	keyring? ( dev-python/keyring[${PYTHON_USEDEP}] )
	mysql? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	redis? ( dev-python/redis-py[${PYTHON_USEDEP}] )
	selinux? ( sec-policy/selinux-salt )
	timelib? ( dev-python/timelib[${PYTHON_USEDEP}] )
	nova? ( >=dev-python/python-novaclient-2.17.0[${PYTHON_USEDEP}] )
	gnupg? ( dev-python/python-gnupg[${PYTHON_USEDEP}] )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/timelib[${PYTHON_USEDEP}]
		>=dev-python/SaltTesting-2015.2.16[${PYTHON_USEDEP}]
		${RDEPEND}
	)"

DOCS=(README.rst AUTHORS)

REQUIRED_USE="|| ( raet zeromq )"

PATCHES=(
	"${FILESDIR}/${PN}-2014.7.1-remove-pydsl-includes-test.patch"
	"${FILESDIR}/${PN}-2014.7.5-archive-test.patch"
)

python_prepare() {
	# this test fails because it trys to "pip install distribute"
	rm tests/unit/{modules,states}/zcbuildout_test.py
}

python_install_all() {
	USE_SETUPTOOLS=1 distutils-r1_python_install_all

	for s in minion master syndic $(use api && echo api); do
		newinitd "${FILESDIR}"/${s}-initd-3 salt-${s}
		newconfd "${FILESDIR}"/${s}-confd-1 salt-${s}
		systemd_dounit "${FILESDIR}"/salt-${s}.service
	done

	insinto /etc/${PN}
	doins -r conf/*
}

python_test() {
	# testsuite likes lots of files
	ulimit -n 3072

	# using ${T} for the TMPDIR makes some tests needs paths that exceed PATH_MAX
	USE_SETUPTOOLS=1 SHELL="/bin/bash" TMPDIR="/tmp" \
		${EPYTHON} tests/runtests.py \
		--unit-tests --no-report --verbose || die "testing failed"
}
