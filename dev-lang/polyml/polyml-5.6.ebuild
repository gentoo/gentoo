# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools pax-utils

DESCRIPTION="Poly/ML is a full implementation of Standard ML"
HOMEPAGE="https://www.polyml.org"
SRC_URI="https://codeload.github.com/polyml/polyml/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="X elibc_glibc +gmp portable test +threads"
RESTRICT="!test? ( test )"

RDEPEND="X? ( x11-libs/motif:0 )
		gmp? ( >=dev-libs/gmp-5 )
		elibc_glibc? ( threads? ( >=sys-libs/glibc-2.13 ) )
		virtual/libffi"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-ffi3.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--disable-static \
		--with-system-libffi \
		--with-pic=pic-only \
		$(use_with X x) \
		$(use_with gmp) \
		$(use_with portable) \
		$(use_with threads)
}

src_compile() {
	# Bug 453146 - dev-lang/polyml-5.5.0: fails to build (pax kernel?)
	pushd libpolyml || die "Could not cd to libpolyml"
	emake
	popd
	emake polyimport
	pax-mark m "${S}/.libs/polyimport"
	emake
	pax-mark m "${S}/.libs/poly"
}

src_test() {
	emake tests
}
