# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="git://git.code.sf.net/p/libwpd/libodfgen"
inherit eutils
[[ ${PV} == 9999 ]] && inherit autotools git-r3

DESCRIPTION="Library to generate ODF documents from libwpd and libwpg"
HOMEPAGE="http://libwpd.sf.net"
[[ ${PV} == 9999 ]] || SRC_URI="mirror://sourceforge/libwpd/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0"

[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

IUSE="doc"

RDEPEND="
	dev-libs/librevenge
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.46
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	eapply_user
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--disable-werror \
		--with-sharedptr=boost \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_with doc docs)
}

src_install() {
	default
	prune_libtool_files --all
}
