# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg

DESCRIPTION="Lightweight, graphical wifi management utility for Linux"
HOMEPAGE="https://github.com/J-Lentz/iwgtk"
SRC_URI="https://github.com/J-Lentz/iwgtk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/atk:0
	dev-libs/glib:2
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	gui-libs/gtk:4
	x11-libs/pango:0
"

RDEPEND="
	${DEPEND}
	net-wireless/iwd
"

src_prepare() {
	default
	sed -i \
		-e 's/^CC=/CC?=/' \
		-e 's/^CFLAGS=/CFLAGS:=$(CFLAGS) /' \
		-e 's/^LDLIBS=/LDLIBS:=$(LDFLAGS) /' \
		-e 's/-O3$/${CFLAGS}/' \
		Makefile || die
}

src_install() {
	emake PREFIX="${ED}/usr" install
	gunzip "${ED}/usr/share/man/man1/iwgtk.1.gz" || die
}
