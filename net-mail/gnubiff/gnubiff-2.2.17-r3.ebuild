# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#
# This package depends upon deprecated gnome-base/libglade.  An
# upstream but has been filed on this issue.
# (https://sourceforge.net/p/gnubiff/bugs/67/)

EAPI=8
inherit autotools

DESCRIPTION="A mail notification program"
HOMEPAGE="https://gnubiff.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-3+-with-openssl-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug fam nls password"

RDEPEND="
	dev-libs/popt
	>=gnome-base/libglade-2.3
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3:3
	x11-libs/libX11
	x11-libs/pango
	fam? ( virtual/fam )
	password? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	${FILESDIR}/${PN}-2.2.17-fix-nls.patch
	${FILESDIR}/${PN}-2.2.17-configure.patch
    ${FILESDIR}/${PN}-2.2.17-clang.patch
)    
    

src_prepare() {
    default
	eautoreconf
}

src_configure() {
	# note: --disable-gnome is to avoid deprecated gnome-panel-2.x
	local myeconfargs=(
		--disable-gnome
		$(use_enable debug)
		$(use_enable nls)
		$(use_enable fam)
		$(use_with password)
		$(use_with password password-string ${RANDOM}${RANDOM}${RANDOM}${RANDOM})
	)
	econf "${myeconfargs[@]}"
}
