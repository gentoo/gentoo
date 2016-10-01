# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="git://gerrit.libreoffice.org/libzmf"

[[ ${PV} == 9999 ]] && GITECLASS="git-r3 autotools"
inherit eutils ${GITECLASS}
unset GITECLASS

DESCRIPTION="Library for parsing Zoner Callisto/Draw documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libzmf"
[[ ${PV} == 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~x86"

IUSE="debug doc test tools"

RDEPEND="
	dev-libs/icu:=
	dev-libs/librevenge
	media-libs/libpng:0=
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_with doc docs) \
		$(use_enable test tests) \
		$(use_enable tools)
}

src_install() {
	default
	prune_libtool_files --all
}
