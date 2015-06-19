# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/salt/salt-2014.1.13.ebuild,v 1.4 2015/04/17 21:29:28 chutzpah Exp $

EAPI=5

PYTHON_COMPAT=(python2_7)

inherit eutils distutils-r1 systemd

DESCRIPTION="Salt is a remote execution and configuration manager"
HOMEPAGE="http://saltstack.org/"

if [[ ${PV} == 9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/${PN}stack/${PN}.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS=""
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="ldap libcloud libvirt mako mongodb mysql openssl redis timelib test"

RDEPEND=">=dev-python/pyzmq-2.2.0[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/m2crypto[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
		dev-python/pycryptopp[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		libcloud? ( >=dev-python/libcloud-0.14.0[${PYTHON_USEDEP}] )
		sys-apps/pciutils
		mako? ( dev-python/mako[${PYTHON_USEDEP}] )
		ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )
		openssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
		libvirt? ( dev-python/libvirt-python[${PYTHON_USEDEP}] )
		mongodb? ( dev-python/pymongo[${PYTHON_USEDEP}] )
		mysql? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
		redis? ( dev-python/redis-py[${PYTHON_USEDEP}] )
		timelib? ( dev-python/timelib[${PYTHON_USEDEP}] )"
DEPEND="test? (
			dev-python/pip
			dev-python/virtualenv
			dev-python/timelib
			>=dev-python/SaltTesting-2014.4.24
			${RDEPEND}
		)"

PATCHES=(
	"${FILESDIR}/${PN}-2014.1.2-tests-nonroot.patch"
	"${FILESDIR}/${PN}-2014.1.5-tests-nonroot.patch"
)
DOCS=(README.rst AUTHORS)

python_prepare() {
	sed -i '/install_requires=/ d' setup.py || die "sed failed"

	# this test fails because it trys to "pip install distribute"
	rm tests/unit/{modules,states}/zcbuildout_test.py
}

python_install_all() {
	USE_SETUPTOOLS=1 distutils-r1_python_install_all

	for s in minion master syndic; do
		newinitd "${FILESDIR}"/${s}-initd-3 salt-${s}
		newconfd "${FILESDIR}"/${s}-confd-1 salt-${s}
		systemd_dounit "${FILESDIR}"/salt-${s}.service
	done

	insinto /etc/${PN}
	doins conf/*
}

python_test() {
	# testsuite likes lots of files
	ulimit -n 3072
	USE_SETUPTOOLS=1 SHELL="/bin/bash" TMPDIR=/tmp ./tests/runtests.py --unit-tests --no-report --verbose || die
}
