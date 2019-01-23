# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MESON_AUTO_DEPEND="no"
inherit meson

DESCRIPTION="Library to help create and query binary XML blobs"
HOMEPAGE="https://github.com/hughsie/libxmlb"
SRC_URI="https://github.com/hughsie/libxmlb/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="doc introspection stemmer test"

RDEPEND="
	dev-libs/glib:2
	sys-apps/util-linux
	stemmer? ( dev-libs/snowball-stemmer )
"

DEPEND="
	${RDEPEND}
	>=dev-util/meson-0.47.0
	doc? ( dev-util/gtk-doc )
	introspection? ( dev-libs/gobject-introspection )
"

BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dgtkdoc="$(usex doc true false)"
		-Dintrospection="$(usex introspection true false)"
		-Dstemmer="$(usex stemmer true false)"
		-Dtests="$(usex test true false)"
	)
	meson_src_configure
}
