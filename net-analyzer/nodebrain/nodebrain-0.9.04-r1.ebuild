# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Monitor and do event correlation"
HOMEPAGE="http://nodebrain.sourceforge.net/"
SRC_URI="mirror://sourceforge/nodebrain/nodebrain-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
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
	"${FILESDIR}"/${PN}-0.9.04-include.patch
)

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--include=/usr/include
}

src_install() {
	default

	prune_libtool_files

	dodoc -r AUTHORS ChangeLog NEWS README THANKS sample/ html/
}
