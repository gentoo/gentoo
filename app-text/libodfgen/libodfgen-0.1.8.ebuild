# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edo

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.code.sf.net/p/libwpd/libodfgen"
	inherit autotools git-r3
else
	SRC_URI="https://downloads.sourceforge.net/libwpd/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Library to generate ODF documents from libwpd and libwpg"
HOMEPAGE="http://libwpd.sourceforge.net/"

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/librevenge
	dev-libs/libxml2:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.8-gcc15-cstdint.patch
)

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_with doc docs) \
		$(use_enable test)
}

src_test() {
	cd test || die

	# TODO: send patch upstream to have 'make check' run these
	while read -r test_name ; do
		edo "${test_name}"
	done < <(find . -maxdepth 1  -type f -executable || die)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
