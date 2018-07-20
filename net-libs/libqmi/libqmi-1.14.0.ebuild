# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit multilib
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/libqmi.git"
else
	KEYWORDS="~amd64 ~arm ~mips ~x86"
	SRC_URI="https://www.freedesktop.org/software/libqmi/${P}.tar.xz"
fi

DESCRIPTION="QMI modem protocol helper library"
HOMEPAGE="https://cgit.freedesktop.org/libqmi/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="doc static-libs"

RDEPEND=">=dev-libs/glib-2.32"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	virtual/pkgconfig"
[[ ${PV} == "9999" ]] && DEPEND+=" dev-util/gtk-doc" #469214

src_prepare() {
	[[ -e configure ]] || eautoreconf
}

src_configure() {
	econf \
		--disable-more-warnings \
		$(use_enable static{-libs,}) \
		$(use_enable {,gtk-}doc)
}

src_install() {
	default
	use static-libs || rm -f "${ED}/usr/$(get_libdir)/${PN}-glib.la"
}
