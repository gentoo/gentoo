# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libmbim/libmbim-1.6.0.ebuild,v 1.7 2014/10/11 12:28:53 maekke Exp $

EAPI="5"

inherit multilib
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="git://anongit.freedesktop.org/${PN}"
else
	KEYWORDS="~alpha amd64 arm ~mips x86"
	SRC_URI="http://www.freedesktop.org/software/${PN}/${P}.tar.xz"
fi

DESCRIPTION="MBIM modem protocol helper library"
HOMEPAGE="http://cgit.freedesktop.org/libmbim/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="doc static-libs test"

RDEPEND=">=dev-libs/glib-2.32"
DEPEND="${RDEPEND}
	virtual/libgudev
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
		$(use_enable {,gtk-}doc) \
		$(use_with test{,s})
}

src_install() {
	default
	use static-libs || rm -f "${ED}/usr/$(get_libdir)/${PN}-glib.la"
}
