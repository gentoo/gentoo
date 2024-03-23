# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Port of the Adobe XMP SDK to work on UNIX"
HOMEPAGE="https://libopenraw.freedesktop.org/wiki/Exempi"
SRC_URI="https://libopenraw.freedesktop.org/download/${P}.tar.xz"

LICENSE="BSD"
SLOT="2/8"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/expat-2:=
	sys-libs/zlib
	virtual/libiconv
"
DEPEND="
	${RDEPEND}
	test? ( dev-libs/boost )
"
BDEPEND="
	dev-build/autoconf-archive
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.2-iconv.patch
)

src_prepare() {
	default

	# Needed for autoconf 2.71
	config_rpath_update .
	eautoreconf
}

src_configure() {
	# ODR & SA violations
	filter-lto
	append-flags -fno-strict-aliasing

	# - --enable-static as --disable-static breaks build
	# - Valgrind detection is "disabled" due to bug #295875
	econf \
		--enable-static \
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

	# --disable-static breaks tests
	rm -rf "${ED}/usr/$(get_libdir)/libexempi.a" || die

	find "${ED}" -name '*.la' -delete || die
}
