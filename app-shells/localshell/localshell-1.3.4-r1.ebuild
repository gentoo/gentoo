# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit base eutils

DESCRIPTION="Localshell allows per-user/group local control of shell execution"
HOMEPAGE="http://git.orbis-terrarum.net/?p=infrastructure/localshellc.git;a=summary"
SRC_URI="${HOMEPAGE}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

src_configure() {
	# this is a shell, it needs to be in /bin
	econf --bindir=/bin --sysconfdir=/etc
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	rm -f "${D}"/usr/share/doc/${PF}/{COPYING,INSTALL}
}

pkg_postinst() {
	elog "Remember to add /bin/localshell to /etc/shells and create"
	elog "/etc/localshell.conf based on the included configuration examples"
}
