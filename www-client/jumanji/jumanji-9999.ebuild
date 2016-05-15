# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils savedconfig git-2 toolchain-funcs

DESCRIPTION="highly customizable and functional web browser with minimalistic and space saving interface"
HOMEPAGE="http://pwmt.org/projects/jumanji"
EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
EGIT_BRANCH=develop

LICENSE="ZLIB"
SLOT="develop"
KEYWORDS=""
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
