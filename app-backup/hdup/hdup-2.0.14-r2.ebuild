# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Hdup is backup program using tar, find, gzip/bzip2, mcrypt and ssh"
HOMEPAGE="http://www.miek.nl/projects/hdup2/index.html"
SRC_URI="http://www.miek.nl/projects/${PN}2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="crypt"

DEPEND="
	app-arch/bzip2
	app-arch/gzip
	app-arch/tar
	>=dev-libs/glib-2.0"
RDEPEND="
	${DEPEND}
	virtual/openssh
	sys-apps/coreutils
	sys-apps/findutils
	crypt? ( app-crypt/mcrypt )"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-fix-build-system.patch )

src_prepare() {
	default
	eautoconf # bug 906003
}

src_install() {
	HTML_DOCS=( doc/FAQ.html )
	default
	dodoc -r Credits examples

	insinto /usr/share/${PN}
	doins -r contrib
}

pkg_postinst() {
	elog "Now edit your /etc/hdup/${PN}.conf to configure your backups."
	elog "You can also check included examples and contrib, see /usr/share/${PN}/."
}
