# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Hdup is backup program using tar, find, gzip/bzip2, mcrypt and ssh"
HOMEPAGE="http://www.miek.nl/projects/hdup2/index.html"
SRC_URI="http://www.miek.nl/projects/${PN}2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="crypt"

CDEPEND="
	app-arch/bzip2
	app-arch/gzip
	app-arch/tar
	>=dev-libs/glib-2.0"
RDEPEND="
	${CDEPEND}
	net-misc/openssh
	sys-apps/coreutils
	sys-apps/findutils
	crypt? ( app-crypt/mcrypt )"
DEPEND="
	${CDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-2.0.14-fix-build-system.patch )

src_install() {
	HTML_DOCS=( doc/FAQ.html )
	default
	dodoc Credits

	insinto /usr/share/${PN}
	doins -r contrib examples
}

pkg_postinst() {
	elog "Now edit your /etc/hdup/${PN}.conf to configure your backups."
	elog "You can also check included examples and contrib, see /usr/share/${PN}/."
}
