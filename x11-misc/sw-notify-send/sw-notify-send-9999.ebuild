# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/mgorny/tinynotify-send.git"
inherit autotools git-r3

MY_P=tinynotify-send-${PV}
DESCRIPTION="A system-wide variant of tinynotify-send"
HOMEPAGE="https://github.com/mgorny/tinynotify-send/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/libtinynotify:0=
	~x11-libs/libtinynotify-cli-${PV}
	x11-libs/libtinynotify-systemwide:0="
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-library
		--disable-regular
		--enable-system-wide
	)

	econf "${myconf[@]}"
}
