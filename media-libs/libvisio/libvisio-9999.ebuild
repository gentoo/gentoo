# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

EGIT_REPO_URI="https://anongit.freedesktop.org/git/libreoffice/libvisio.git"
[[ ${PV} == 9999 ]] && inherit autotools git-r3

DESCRIPTION="Library parsing the visio documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
[[ ${PV} == 9999 ]] || SRC_URI="https://dev-www.libreoffice.org/src/libvisio/${P}.tar.xz"

LICENSE="|| ( GPL-2+ LGPL-2.1 MPL-1.1 )"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="doc static-libs test tools"

RDEPEND="
	dev-libs/icu:=
	dev-libs/librevenge
	dev-libs/libxml2
"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-libs/boost
	dev-util/gperf
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	# bug 619688
	append-cxxflags -std=c++14

	econf \
		$(use_with doc docs) \
		$(use_enable static-libs static) \
		$(use_enable test tests) \
		$(use_enable tools)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
