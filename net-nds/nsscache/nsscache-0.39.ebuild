# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit eutils distutils-r1

DESCRIPTION="commandline tool to sync directory services to local cache"
HOMEPAGE="https://github.com/google/nsscache"
SCRIPT_A='nsscache-0.30-r3-gentoo-authorized-keys-command.py'
SRC_URI="
	https://github.com/google/nsscache/archive/version/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~robbat2/${SCRIPT_A}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
IUSE="nsscache s3"

DEPEND="${PYTHON_DEPS}
		dev-python/ldap3[${PYTHON_USEDEP}]
		dev-python/pycurl[${PYTHON_USEDEP}]
		dev-python/bsddb3[${PYTHON_USEDEP}]
		s3? ( dev-python/boto3[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}
		nsscache? ( >=sys-auth/libnss-cache-0.10 )"
RESTRICT="test" # requires network
S="${WORKDIR}/${PN}-version-${PV}"

src_prepare() {
	sed -i \
		-e "/setup_requires/s,'pytest-runner',,g" \
		-e '/tests_require/s,\[.*\],[],g' \
		"${S}"/setup.py || die
	sed -i \
		-e '/test=pytest/d' \
		"${S}"/setup.cfg || die
	sed -i \
		-e '/pytest/d' \
		"${S}"/requirements.txt || die
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile --verbose
}

src_install() {
	distutils-r1_src_install

	doman nsscache.1 nsscache.conf.5
	dodoc THANKS nsscache.cron CONTRIBUTING.md README.md
	exeinto /usr/libexec/nsscache
	newexe "${DISTDIR}"/"${SCRIPT_A}" authorized-keys-command.py

	keepdir /var/lib/nsscache
}
