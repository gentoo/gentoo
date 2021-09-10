# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools pax-utils

DESCRIPTION="Poly/ML is a full implementation of Standard ML"
HOMEPAGE="https://www.polyml.org"
SRC_URI="https://codeload.github.com/polyml/polyml/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="X elibc_glibc +gmp portable test"
RESTRICT="!test? ( test )"

RDEPEND="X? ( x11-libs/motif:0 )
	gmp? ( >=dev-libs/gmp-5 )
	dev-libs/libffi:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.8.2-configure.patch
	"${FILESDIR}"/${PN}-5.8.2-glibc234.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--disable-static \
		--with-pic=pic-only \
		$(use_with X x) \
		$(use_with gmp) \
		$(use_enable !portable native-codegeneration)
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
