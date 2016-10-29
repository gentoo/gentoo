# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools xdg-utils

DESCRIPTION="A CLI utility to control media players over MPRIS"
HOMEPAGE="https://github.com/acrisci/playerctl"
SRC_URI="https://github.com/acrisci/playerctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc introspection"

RDEPEND="
	dev-libs/glib:2
	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/gtk-doc-am
	doc? ( dev-util/gtk-doc )
	virtual/pkgconfig
"

src_prepare() {
	if ! use doc; then
		echo 'EXTRA_DIST = ' > gtk-doc.make || die
	fi

	default
	eautoreconf
}

src_configure() {
	xdg_environment_reset # 596166

	econf \
		$(use_enable doc gtk-doc) \
		$(use_enable doc gtk-doc-html) \
		$(use_enable introspection)
}

src_compile() {
	emake -j1
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
