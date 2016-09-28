# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit multilib
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="git://anongit.freedesktop.org/${PN}"
else
	KEYWORDS="~amd64 ~arm ~mips ~x86"
	SRC_URI="https://www.freedesktop.org/software/${PN}/${P}.tar.xz"
fi

DESCRIPTION="QMI modem protocol helper library"
HOMEPAGE="https://cgit.freedesktop.org/libqmi/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="doc +mbim static-libs"

RDEPEND=">=dev-libs/glib-2.32"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	mbim? ( >=net-libs/libmbim-1.14.0 )
	virtual/pkgconfig"
[[ ${PV} == "9999" ]] && DEPEND+=" dev-util/gtk-doc" #469214

src_prepare() {
	eapply_user
	[[ -e configure ]] || eautoreconf
}

src_configure() {
	econf \
		--disable-more-warnings \
		$(use_enable mbim mbim-qmux ) \
		$(use_enable static{-libs,}) \
		$(use_enable {,gtk-}doc)
}

src_install() {
	default
	use static-libs || rm -f "${ED}/usr/$(get_libdir)/${PN}-glib.la"
}
