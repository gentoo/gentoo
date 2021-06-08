# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Port of the Adobe XMP SDK to work on UNIX"
HOMEPAGE="https://libopenraw.freedesktop.org/wiki/Exempi"
SRC_URI="https://libopenraw.freedesktop.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="2/3"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/expat-2:=
	sys-libs/zlib
	virtual/libiconv"
DEPEND="
	${RDEPEND}
	test? ( dev-libs/boost )"
BDEPEND="
	sys-devel/autoconf-archive
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.2-iconv.patch
	"${FILESDIR}"/${P}-CVE-2018-12648.patch
	"${FILESDIR}"/${P}-gcc11.patch
)

src_prepare() {
	default

	config_rpath_update .
	eautoreconf
}

src_configure() {
	# Valgrind detection is "disabled" due to bug #295875
	econf \
		--disable-static \
		$(use_enable test unittest) \
		VALGRIND=""
}

src_install() {
	default

	if use examples; then
		emake -C samples/source distclean
		rm samples/{,source,testfiles}/Makefile* || die
		docinto examples
		dodoc -r samples/.
	fi

	find "${ED}" -name '*.la' -delete || die
}
