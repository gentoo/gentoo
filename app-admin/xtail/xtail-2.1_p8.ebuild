# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

MY_PV=$(ver_cut 1-2)
DESCRIPTION="Tail multiple logfiles at once, even if rotated"
HOMEPAGE="http://www.unicom.com/sw/xtail/"
SRC_URI="
	http://www.unicom.com/sw/xtail/${PN}-${MY_PV}.tar.gz
	http://www.unicom.com/files/20120219-patch-aalto.zip
	mirror://debian/pool/main/x/xtail/xtail_${MY_PV}-$(ver_cut 4).debian.tar.xz
"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-rename-configure.patch
	"${FILESDIR}"/${P}-fix-prototype.patch
	"${FILESDIR}"/${P}-fix-limits-musl.patch

	"${WORKDIR}"/0001-xtail.1-remove-SIGQUIT.patch
	"${WORKDIR}"/debian/patches/
)

src_prepare() {
	default

	# Needed for -Wimplicit-int in old configure
	eautoreconf
}

src_configure() {
	tc-export CC
	default
}

src_install() {
	dobin xtail
	doman xtail.1
	dodoc README
	newdoc ../README README.patches
}
