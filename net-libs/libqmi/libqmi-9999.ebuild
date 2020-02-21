# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit multilib
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/libqmi.git"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
	SRC_URI="https://www.freedesktop.org/software/libqmi/${P}.tar.xz"
fi

DESCRIPTION="Qualcomm MSM (Mobile Station Modem) Interface (QMI) modem protocol helper library"
HOMEPAGE="https://cgit.freedesktop.org/libqmi/"

LICENSE="LGPL-2"
SLOT="0/5.1"	# soname of libqmi-glib.so
IUSE="doc +mbim static-libs"

RDEPEND=">=dev-libs/glib-2.36
	dev-libs/libgudev
	mbim? ( >=net-libs/libmbim-1.14.0 )"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	virtual/pkgconfig"
[[ ${PV} == "9999" ]] && DEPEND+=" dev-util/gtk-doc" #469214

src_prepare() {
	default
	[[ -e configure ]] || eautoreconf
}

src_configure() {
	econf \
		--disable-more-warnings \
		$(use_enable mbim mbim-qmux) \
		$(use_enable static{-libs,}) \
		$(use_enable {,gtk-}doc)
}

src_install() {
	default
	use static-libs || rm -f "${ED}/usr/$(get_libdir)/${PN}-glib.la"
}
