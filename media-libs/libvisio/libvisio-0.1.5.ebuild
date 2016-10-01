# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="git://anongit.freedesktop.org/git/libreoffice/libvisio/"
inherit autotools eutils
[[ ${PV} == 9999 ]] && inherit git-r3

DESCRIPTION="Library parsing the visio documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
[[ ${PV} == 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="|| ( GPL-2+ LGPL-2.1 MPL-1.1 )"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="amd64 ~arm hppa ppc64 x86"
IUSE="doc static-libs test tools"

RDEPEND="
	dev-libs/icu:=
	dev-libs/librevenge
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-lang/perl
	>=dev-libs/boost-1.46
	dev-util/gperf
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

PATCHES=( "${FILESDIR}/${PN}-0.1.3-tests-without-tools.patch" )

src_prepare() {
	eapply "${PATCHES[@]}"
	eapply_user
	[[ -d m4 ]] || mkdir "m4"
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable static-libs static) \
		--disable-werror \
		$(use_with doc docs) \
		$(use_enable test tests) \
		$(use_enable tools)
}

src_install() {
	default
	prune_libtool_files --all
}
