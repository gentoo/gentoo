# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils git-r3

DESCRIPTION="Monitor and do event correlation"
HOMEPAGE="http://nodebrain.sourceforge.net/"
EGIT_REPO_URI="https://github.com/trettevik/nodebrain-nb"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

CDEPEND="
	dev-libs/libedit
"
DEPEND="
	${CDEPEND}
	dev-lang/perl
	virtual/pkgconfig
	sys-apps/texinfo
"
RDEPEND="
	${CDEPEND}
	!sys-boot/netboot
	!www-apps/nanoblogger
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.8.14-include.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--include=/usr/include
}

src_install() {
	default

	dodoc -r AUTHORS ChangeLog NEWS README THANKS sample/ html/

	prune_libtool_files
}
