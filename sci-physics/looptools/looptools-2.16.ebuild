# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 toolchain-funcs flag-o-matic

MY_P=LoopTools-${PV}

DESCRIPTION="Tools for evaluation of scalar and tensor one-loop integrals"
HOMEPAGE="http://www.feynarts.de/looptools"
SRC_URI="http://www.feynarts.de/looptools/${MY_P}.tar.gz"

LICENSE="LGPL-3"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-configure.patch
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	export VER="${PV}"
	# necessary fix for prefix
	sed -i "s/lib\$(LIBDIRSUFFIX)/$(get_libdir)/" makefile.in || die
}

src_configure() {
	# fortran C bindings are not LTO compatible
	filter-lto
	econf CONF_CC=$(tc-getCC) CONF_CXX=$(tc-getCXX) CONF_FC=$(tc-getFC)
}

src_install() {
	default

	dolib.so build/libooptools.so
	# The name used for requesting this library varies
	dosym libooptools.so /usr/$(get_libdir)/libooptools.so.2.16

	rm "${ED}"/usr/$(get_libdir)/libooptools.a || die
	use doc && dodoc manual/*.pdf
}
