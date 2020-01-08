# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit multilib
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/libmbim/libmbim.git"
else
	KEYWORDS="~alpha amd64 arm ~mips x86"
	SRC_URI="https://www.freedesktop.org/software/libmbim/${P}.tar.xz"
fi

DESCRIPTION="MBIM modem protocol helper library"
HOMEPAGE="https://cgit.freedesktop.org/libmbim/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="static-libs"

RDEPEND=">=dev-libs/glib-2.32:2
	dev-libs/libgudev:="
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/gtk-doc-am
	virtual/pkgconfig"
[[ ${PV} == "9999" ]] && DEPEND+=" dev-util/gtk-doc" #469214

src_prepare() {
	[[ -e configure ]] || eautoreconf
}

src_configure() {
	econf \
		--disable-more-warnings \
		--disable-gtk-doc \
		$(use_enable static{-libs,})
}

src_install() {
	default
	use static-libs || rm -f "${ED}/usr/$(get_libdir)/${PN}-glib.la"
}
