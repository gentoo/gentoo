# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

EGIT_REPO_URI="https://anongit.freedesktop.org/git/libreoffice/libfreehand.git"
[[ ${PV} == 9999 ]] && inherit autotools git-r3

DESCRIPTION="Library for import of FreeHand drawings"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"
[[ ${PV} == 9999 ]] || SRC_URI="https://dev-www.libreoffice.org/src/libfreehand/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="amd64 ~arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/librevenge
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-libs/icu
	dev-util/gperf
	media-libs/lcms
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

PATCHES=( "${FILESDIR}/${P}-icu-65.patch" )

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	# bug 619762
	append-cxxflags -std=c++14

	econf \
		--disable-werror \
		$(use_with doc docs) \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
