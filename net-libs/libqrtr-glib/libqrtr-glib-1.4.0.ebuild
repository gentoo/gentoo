# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mobile-broadband/libqrtr-glib.git"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
	SRC_URI="https://gitlab.freedesktop.org/mobile-broadband/${PN}/-/archive/${PV}/${P}.tar.bz2"
fi

DESCRIPTION="Qualcomm IPC Router protocol helper library"
HOMEPAGE="https://gitlab.freedesktop.org/mobile-broadband/libqrtr-glib"

LICENSE="LGPL-2"
SLOT="0/0"	# soname of libqrtr-glib.so
IUSE="gtk-doc"

RDEPEND="
	>=dev-libs/glib-2.56:2
	>=dev-libs/gobject-introspection-1.82.0-r2
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? ( >=dev-util/gi-docgen-2021.1 )
"

src_configure() {
	local emesonargs=(
		-Dintrospection=true
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use gtk-doc ; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html || die
		mv "${D}"/usr/share/doc/libqrtr-glib-*/ "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
