# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DEB_PV=20100827
DEB_PR=1
DEB_P=${PN}_${DEB_PV}

DESCRIPTION="Fortran to C converter"
HOMEPAGE="https://www.netlib.org/f2c"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_P}-${DEB_PR}.debian.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-libs/libf2c-20130927-r1"

S="${WORKDIR}/${PN}"

PATCHES=(
	# selective list of patches from debian
	"${WORKDIR}"/debian/patches/0000-prequilt-tweaks.patch
	"${WORKDIR}"/debian/patches/0002-prototype-rmdir.patch
	"${WORKDIR}"/debian/patches/0003-struct-init-braces.patch
	"${WORKDIR}"/debian/patches/0004-man-dash-hyphen-slash.patch

	"${FILESDIR}"/${PN}-20100827-fix-buildsystem.patch
	"${FILESDIR}"/${PN}-20100827-Wimplicit-function-declaration.patch
)

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/855593
	#
	append-flags -fno-strict-aliasing
	filter-lto

	tc-export CC
}

src_compile() {
	emake -C src -f makefile.u f2c
}

src_install() {
	dobin src/f2c

	doman f2c.1
	dodoc src/README src/Notice

	dodoc f2c.pdf
	newdoc "${WORKDIR}"/debian/changelog debian.changelog
}
