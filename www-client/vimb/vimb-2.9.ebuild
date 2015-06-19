# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/vimb/vimb-2.9.ebuild,v 1.3 2015/03/25 13:38:37 ago Exp $

EAPI=5

inherit toolchain-funcs eutils

DESCRIPTION="a fast, lightweight, vim-like browser based on webkit"
HOMEPAGE="http://fanglingsu.github.io/vimb/"
SRC_URI="https://github.com/fanglingsu/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk3"

RDEPEND="
	>=net-libs/libsoup-2.38:2.4
	!gtk3? (
		>=net-libs/webkit-gtk-1.5.0:2
		x11-libs/gtk+:2
	)
	gtk3? (
		>=net-libs/webkit-gtk-1.5.0:3
		x11-libs/gtk+:3
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# force verbose build
	sed -e '/@echo "\($(CC)\|${CC}\) $@"/d' \
		-e 's/@$(CC)/$(CC)/' \
		-i Makefile || die

	epatch_user
}

src_compile() {
	local myconf
	use gtk3 && myconf+=" GTK=3"

	emake CC="$(tc-getCC)" ${myconf}
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install
}
