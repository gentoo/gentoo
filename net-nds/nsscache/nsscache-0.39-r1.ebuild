# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit distutils-r1

DESCRIPTION="commandline tool to sync directory services to local cache"
HOMEPAGE="https://github.com/google/nsscache"
SCRIPT_A='nsscache-0.30-r3-gentoo-authorized-keys-command.py'
SRC_URI="
	https://github.com/google/nsscache/archive/version/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~robbat2/${SCRIPT_A}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="berkdb nsscache s3"
RESTRICT="test" # requires network

DEPEND="
	dev-python/ldap3[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	berkdb? ( dev-python/bsddb3[${PYTHON_USEDEP}] )
	s3? ( dev-python/boto3[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}
	nsscache? ( >=sys-auth/libnss-cache-0.10 )"

S="${WORKDIR}/${PN}-version-${PV}"

python_prepare_all() {
	sed -i \
		-e "/setup_requires/s,'pytest-runner',,g" \
		-e '/tests_require/s,\[.*\],[],g' \
		setup.py || die
	sed -i \
		-e '/test=pytest/d' \
		setup.cfg || die
	sed -i \
		-e '/pytest/d' \
		requirements.txt || die

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile --verbose
}

python_install() {
	distutils-r1_python_install

	python_scriptinto /usr/libexec/nsscache
	python_newexe "${DISTDIR}"/"${SCRIPT_A}" authorized-keys-command.py
}

python_install_all() {
	distutils-r1_python_install_all

	doman nsscache.1 nsscache.conf.5
	dodoc THANKS nsscache.cron CONTRIBUTING.md README.md

	keepdir /var/lib/nsscache
}
