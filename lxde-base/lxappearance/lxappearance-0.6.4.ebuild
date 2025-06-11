# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="LXDE GTK+ theme switcher"
HOMEPAGE="https://wiki.lxde.org/en/LXAppearance"
SRC_URI="https://github.com/lxde/lxappearance/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="dbus"

RDEPEND="
	>=dev-libs/glib-2.26.0:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	dbus? ( >=dev-libs/dbus-glib-0.70 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=app-text/docbook-xsl-stylesheets-1.70.1
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local econfargs=(
		--enable-gtk3
		$(use_enable dbus)
		# As of 0.6.4, there's no more dist tarballs, but we
		# still want man pages.
		--enable-man
	)

	econf "${myeconfargs[@]}"
}
