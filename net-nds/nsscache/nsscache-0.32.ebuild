# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

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
IUSE="nsscache"

DEPEND="${PYTHON_DEPS}
		dev-python/python-ldap[${PYTHON_USEDEP}]
		dev-python/pycurl[${PYTHON_USEDEP}]
		dev-python/bsddb3[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
		nsscache? ( >=sys-auth/libnss-cache-0.10 )"
RESTRICT="test"
S="${WORKDIR}/${PN}-version-${PV}"

src_prepare() {
	find "${S}" -name '*.py' -exec \
		sed -i '/^import bsddb$/s,bsddb,bsddb3 as bsddb,g' \
		{} \+
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

	doman nsscache.1 nsscache.conf.5
	dodoc THANKS nsscache.cron CONTRIBUTING.md README.md
	exeinto /usr/libexec/nsscache
	newexe "${DISTDIR}"/"${SCRIPT_A}" authorized-keys-command.py

	keepdir /var/lib/nsscache
}
