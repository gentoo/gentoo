# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/pfl/pfl-2.4-r4.ebuild,v 1.9 2015/06/02 05:23:41 jmorgan Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit eutils distutils-r1

DESCRIPTION="Searchable online file/package database for Gentoo"
HOMEPAGE="http://www.portagefilelist.de"
SRC_URI="http://files.portagefilelist.de/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x64-freebsd ~amd64-linux ~x86-linux"
IUSE="+network-cron"

DEPEND=""
RDEPEND="${DEPEND}
	net-misc/curl
	sys-apps/portage[${PYTHON_USEDEP}]"

src_prepare() {
	epatch "${FILESDIR}"/e-file-20110906-http-response.patch \
		"${FILESDIR}"/e-file-20110906-portageq.patch \
		"${FILESDIR}"/pfl-2.4-reponame.patch
}

python_install_all() {
	if use network-cron ; then
		exeinto /etc/cron.weekly
		doexe cron/pfl
	fi

	keepdir /var/lib/${PN}
	distutils-r1_python_install_all
}

pkg_postinst() {
	if [[ ! -e "${EROOT%/}/var/lib/${PN}/pfl.info" ]]; then
		touch "${EROOT%/}/var/lib/${PN}/pfl.info" || die
		chown -R 0:portage "${EROOT%/}/var/lib/${PN}" || die
		chmod 775 "${EROOT%/}/var/lib/${PN}" || die
	fi
}
