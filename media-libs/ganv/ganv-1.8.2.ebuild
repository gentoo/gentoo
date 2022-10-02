# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A GTK+ widget for interactive graph-like environments"
HOMEPAGE="https://drobilla.net/software/ganv.html"
SRC_URI="https://download.drobilla.net/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+fdgl +graphviz introspection nls"

RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	x11-libs/gtk+:2
	graphviz? ( media-gfx/graphviz[gtk2] )
	introspection? (
		app-text/yelp-tools
		dev-libs/gobject-introspection:=[doctool]
	)
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	nls? ( virtual/libintl )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.8.2-make-intl-check-non-required.patch"
)

src_configure() {
	local emesonargs=(
		$(meson_feature fdgl)
		$(meson_feature graphviz)
		$(meson_feature introspection gir)
		$(meson_feature nls)
	)

	meson_src_configure
}
