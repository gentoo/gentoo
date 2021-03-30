# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mobile-broadband/libqmi.git"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
	SRC_URI="https://www.freedesktop.org/software/libqmi/${P}.tar.xz"
fi

DESCRIPTION="Qualcomm MSM (Mobile Station Modem) Interface (QMI) modem protocol library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libqmi/ https://gitlab.freedesktop.org/mobile-broadband/libqmi"

LICENSE="LGPL-2"
SLOT="0/5.7"	# soname of libqmi-glib.so
IUSE="gtk-doc +mbim"

RDEPEND=">=dev-libs/glib-2.48
	dev-libs/libgudev
	mbim? ( >=net-libs/libmbim-1.18.0 )"
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
		--disable-qrtr # libqrtr-glib not packaged
		$(use_enable mbim mbim-qmux)
		$(use_enable gtk-doc)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
