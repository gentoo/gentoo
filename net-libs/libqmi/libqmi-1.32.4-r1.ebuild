# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mobile-broadband/libqmi.git"
else
	SRC_URI="https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 arm arm64 ~loong ~mips ppc ~ppc64 ~riscv ~x86"
fi

inherit bash-completion-r1 meson udev

DESCRIPTION="Qualcomm MSM (Mobile Station Modem) Interface (QMI) modem protocol library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libqmi/ https://gitlab.freedesktop.org/mobile-broadband/libqmi"

LICENSE="LGPL-2"
SLOT="0/5.9" # soname of libqmi-glib.so
IUSE="gtk-doc introspection +mbim +qrtr"

RDEPEND="
	>=dev-libs/glib-2.56
	>=dev-libs/libgudev-232
	introspection? ( dev-libs/gobject-introspection:= )
	mbim? ( >=net-libs/libmbim-1.18.0 )
	qrtr? ( >=net-libs/libqrtr-glib-1.0.0:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
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

		$(meson_use introspection)
		$(meson_use gtk-doc gtk_doc)
		-Dman=true

		# Let's avoid BuildRequiring bash-completion, install it manually
		-Dbash_completion=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	dobashcomp src/qmicli/qmicli
}
