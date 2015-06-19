# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/jumanji/jumanji-0.0.0_p20150527.ebuild,v 1.1 2015/06/01 13:34:30 xmw Exp $

EAPI=5

inherit eutils savedconfig toolchain-funcs vcs-snapshot

DESCRIPTION="highly customizable and functional web browser with minimalistic and space saving interface"
HOMEPAGE="http://pwmt.org/projects/jumanji"
SRC_URI="https://git.pwmt.org/?p=jumanji.git;a=snapshot;h=618488c960aa4613e1b5bed4f864d0438f669b98;sf=tgz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="develop"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite:3
	dev-libs/glib:2
	>=dev-libs/girara-0.2.4:3
	net-libs/webkit-gtk:3
	x11-libs/gtk+:3
	!${CATEGORY}/${PN}:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	restore_config config.h
}

src_compile() {
	emake CC="$(tc-getCC)" SFLAGS="" VERBOSE=1 || \
		die "emake failed$(usex savedconfig ",please check the configfile" "")"
}

src_install() {
	default
	make_desktop_entry ${PN}

	save_config config.h
}
