# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="xml"

inherit distutils-r1

DESCRIPTION="Searchable online file/package database for Gentoo"
HOMEPAGE="http://www.portagefilelist.de"
SRC_URI="http://files.portagefilelist.de/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="+network-cron"

DEPEND=""
RDEPEND="
	${DEPEND}
	net-misc/curl
	sys-apps/portage[${PYTHON_USEDEP}]
	>=dev-python/ssl-fetch-0.4[${PYTHON_USEDEP}]
"

python_install_all() {
	if use network-cron ; then
		exeinto /etc/cron.weekly
		doexe cron/pfl
	fi

	keepdir /var/lib/${PN}
	distutils-r1_python_install_all
}

pkg_postinst() {
	if [[ ! -e "${EROOT}/var/lib/${PN}/pfl.info" ]]; then
		touch "${EROOT}/var/lib/${PN}/pfl.info" || die
		chown -R 0:portage "${EROOT}/var/lib/${PN}" || die
		chmod 775 "${EROOT}/var/lib/${PN}" || die
	fi
}
