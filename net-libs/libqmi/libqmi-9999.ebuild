# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mobile-broadband/libqmi.git"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
	SRC_URI="https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/archive/${PV}/${P}.tar.bz2"
fi

inherit meson udev

DESCRIPTION="Qualcomm MSM (Mobile Station Modem) Interface (QMI) modem protocol library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libqmi/ https://gitlab.freedesktop.org/mobile-broadband/libqmi"

LICENSE="LGPL-2"
SLOT="0/5.8"	# soname of libqmi-glib.so
IUSE="gtk-doc +mbim +qrtr"

RDEPEND="
	>=dev-libs/glib-2.56
	>=dev-libs/libgudev-232
	mbim? ( >=net-libs/libmbim-1.18.0 )
	qrtr? ( >=net-libs/libqrtr-glib-1.0.0:= )

	dev-libs/gobject-introspection:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_configure() {
	local emesonargs=(
		$(meson_use mbim mbim_qmux)
		$(meson_use qrtr)
		-Drmnet=true

		-Dudev=true
		-Dudevdir="$(get_udevdir)"

		-Dintrospection=true
		$(meson_use gtk-doc gtk_doc)
		-Dman=true

		-Dbash_completion=false
	)
	meson_src_configure
}
