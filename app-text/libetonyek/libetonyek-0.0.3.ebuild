# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/libetonyek/libetonyek-0.0.3.ebuild,v 1.5 2014/06/29 16:43:31 ago Exp $

EAPI=5

EGIT_REPO_URI="git://anongit.freedesktop.org/git/libreoffice/libetonyek"
inherit base eutils
[[ ${PV} == 9999 ]] && inherit autotools git-2

DESCRIPTION="Library parsing Apple Keynote presentations"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/libetonyek"
[[ ${PV} == 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${P}.tar.xz"

LICENSE="|| ( GPL-2+ LGPL-2.1 MPL-1.1 )"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="doc static-libs test"

RDEPEND="
	app-text/libwpd:0.9
	dev-libs/boost:=
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.46
	dev-util/gperf
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

PATCHES=(
	"${FILESDIR}/${P}-comma.patch"
	"${FILESDIR}/${P}-lexical_cast.patch"
)

src_prepare() {
	[[ -d m4 ]] || mkdir "m4"
	base_src_prepare
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable static-libs static) \
		--disable-werror \
		$(use_enable test tests) \
		$(use_with doc docs)
}

src_install() {
	default
	prune_libtool_files --all
}
