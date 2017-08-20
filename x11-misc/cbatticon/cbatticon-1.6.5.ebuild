# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs

DESCRIPTION="A lightweight and fast battery icon that sits in your system tray"
HOMEPAGE="https://github.com/ColinJones/cbatticon"
SRC_URI="https://github.com/ColinJones/cbatticon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libnotify"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
	libnotify? ( x11-libs/libnotify )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default

	strip-linguas -i .
}

src_compile() {
	tc-export CC
	emake \
		$(usex libnotify WITH_NOTIFY=1 WITH_NOTIFY=0) \
		V=1 \
		VERSION="${PF}" \
		WITH_GTK3=1
}

src_install() {
	emake \
		DESTDIR="${D}" \
		LANGUAGES="${LINGUAS}" \
		V=1 VERSION="${PF}" \
		install

	dodoc Changelog
}
