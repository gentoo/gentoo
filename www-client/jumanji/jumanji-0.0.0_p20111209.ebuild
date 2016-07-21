# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils savedconfig toolchain-funcs vcs-snapshot

DESCRIPTION="highly customizable and functional web browser with minimalistic and space saving interface"
HOMEPAGE="http://pwmt.org/projects/jumanji"
SRC_URI="https://git.pwmt.org/?p=jumanji.git;a=snapshot;h=614511550b5e4633397f3c26297d5995a5236766;sf=tgz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	dev-libs/libunique:1
	net-libs/libsoup:2.4
	net-libs/webkit-gtk:2
	x11-libs/gtk+:2
	!${CATEGORY}/${PN}:develop"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-buildsystem.patch

	restore_config config.h
}

src_compile() {
	emake CC="$(tc-getCC)" SFLAGS="" V=1 || \
		die "emake failed$(usex savedconfig ",please check the configfile" "")"
}

src_install() {
	default
	make_desktop_entry ${PN}

	save_config config.h
}
