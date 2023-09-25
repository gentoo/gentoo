# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN=fjcontrib
MY_P=${MY_PN}-${PV}

DESCRIPTION="3rd party extensions of FastJet."
HOMEPAGE="https://fastjet.hepforge.org/contrib/"
SRC_URI="https://fastjet.hepforge.org/contrib/downloads/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-physics/fastjet-3.4.0"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-soname.patch
	"${FILESDIR}"/${P}-ar.patch
	"${FILESDIR}"/${P}-musl.patch
)

src_configure() {
	tc-export CXX AR RANLIB
	./configure --prefix=/usr --fastjet-config=/usr/bin/fastjet-config RANLIB="${RANLIB}" AR="${AR}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" FFLAGS="${FFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_compile() {
	emake
	emake fragile-shared
}

src_install() {
	emake install PREFIX="${ED}/usr"
	dolib.so libfastjetcontribfragile.so
	# The name used for requesting this library varies
	dosym libfastjetcontribfragile.so /usr/$(get_libdir)/libfastjetcontribfragile.so.0
	dosym libfastjetcontribfragile.so /usr/$(get_libdir)/fastjetcontribfragile.so.0
}
