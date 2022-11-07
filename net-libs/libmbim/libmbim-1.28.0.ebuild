# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )
inherit meson python-any-r1

DESCRIPTION="Mobile Broadband Interface Model (MBIM) modem protocol helper library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libmbim/ https://gitlab.freedesktop.org/mobile-broadband/libmbim"
SRC_URI="https://gitlab.freedesktop.org/mobile-broadband/libmbim/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-libs/glib-2.56:2
	>=dev-libs/gobject-introspection-0.9.6:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/glib-utils
	sys-apps/help2man
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dintrospection=true
		-Dgtk_doc=false
		-Dman=true

		-Dbash_completion=false
	)
	meson_src_configure
}
