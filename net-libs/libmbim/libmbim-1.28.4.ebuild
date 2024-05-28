# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..11} )
inherit bash-completion-r1 meson python-any-r1

DESCRIPTION="Mobile Broadband Interface Model (MBIM) modem protocol helper library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libmbim/ https://gitlab.freedesktop.org/mobile-broadband/libmbim"
SRC_URI="https://gitlab.freedesktop.org/mobile-broadband/libmbim/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ppc ppc64 ~riscv ~x86"
IUSE="gtk-doc"

RDEPEND="
	>=dev-libs/glib-2.56:2
	>=dev-libs/gobject-introspection-0.9.6:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	gtk-doc? ( dev-util/gtk-doc )
	dev-util/glib-utils
	sys-apps/help2man
	virtual/pkgconfig
"

src_configure() {
	# Let's avoid BuildRequiring bash-completion, install it manually
	local emesonargs=(
		-Dintrospection=true
		-Dman=true
		-Dbash_completion=false
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	dobashcomp src/mbimcli/mbimcli
}
