# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vala

DESCRIPTION="A basic utility library for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/libxfce4util/start
	https://gitlab.xfce.org/xfce/libxfce4util/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0/7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="+introspection vala"
REQUIRED_USE="vala? ( introspection )"

DEPEND="
	>=dev-libs/glib-2.72.0
	introspection? ( >=dev-libs/gobject-introspection-1.72.0:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )"

src_configure() {
	local myconf=(
		$(use_enable introspection)
		$(use_enable vala)
	)

	use vala && vala_setup
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
