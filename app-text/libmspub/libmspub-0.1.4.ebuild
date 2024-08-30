# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/libreoffice/libmspub.git"
	inherit git-r3
else
	SRC_URI="https://dev-www.libreoffice.org/src/libmspub/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
fi
DESCRIPTION="Library parsing Microsoft Publisher documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libmspub"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc static-libs"

RDEPEND="
	dev-libs/icu:=
	dev-libs/librevenge
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-build/libtool
	dev-libs/boost
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

PATCHES=(
	# upstream backport
	"${FILESDIR}/${P}-gcc10.patch"
	# manually backported
	"${FILESDIR}/${P}-gcc15.patch"
)

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"

	# Needed for Clang: stale libtool. bug #832764
	eautoreconf
}

src_configure() {
	# bug 619044, 932494
	append-cxxflags -std=c++17

	local myeconfargs=(
		--disable-werror
		$(use_with doc docs)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
