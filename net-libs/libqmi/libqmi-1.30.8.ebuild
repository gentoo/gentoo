# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mobile-broadband/libqmi.git"
else
	KEYWORDS="~amd64 ~arm arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
	SRC_URI="https://www.freedesktop.org/software/libqmi/${P}.tar.xz"
fi

DESCRIPTION="Qualcomm MSM (Mobile Station Modem) Interface (QMI) modem protocol library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libqmi/ https://gitlab.freedesktop.org/mobile-broadband/libqmi"

LICENSE="LGPL-2"
SLOT="0/5.8"	# soname of libqmi-glib.so
IUSE="gtk-doc +mbim +qrtr"

RDEPEND=">=dev-libs/glib-2.56
	>=dev-libs/libgudev-232
	mbim? ( >=net-libs/libmbim-1.18.0 )
	qrtr? ( >=net-libs/libqrtr-glib-1.0.0:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )"
[[ ${PV} == "9999" ]] && BDEPEND+=" dev-util/gtk-doc" #469214

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	local myconf=(
		--disable-Werror
		--disable-static
		$(use_enable qrtr)
		$(use_enable mbim mbim-qmux)
		$(use_enable gtk-doc)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
