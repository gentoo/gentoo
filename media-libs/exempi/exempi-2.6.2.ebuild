# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Port of the Adobe XMP SDK to work on UNIX"
HOMEPAGE="https://libopenraw.freedesktop.org/wiki/Exempi"
# TODO: switch to xz for 2.6.3
SRC_URI="https://libopenraw.freedesktop.org/download/${P}.tar.bz2"

LICENSE="BSD"
SLOT="2/8"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
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
	sys-devel/autoconf-archive
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.2-iconv.patch
	"${FILESDIR}"/${PN}-2.6.2-arm-static-build.patch
)

src_prepare() {
	default

	config_rpath_update .
	eautoreconf
}

src_configure() {
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
