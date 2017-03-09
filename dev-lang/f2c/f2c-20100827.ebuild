# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs

DEB_PV=20100827
DEB_PR=1
DEB_P=${PN}_${DEB_PV}

DESCRIPTION="Fortran to C converter"
HOMEPAGE="http://www.netlib.org/f2c"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_P}-${DEB_PR}.debian.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="dev-libs/libf2c"
DEPEND=""

S="${WORKDIR}/${PN}"

src_prepare() {
	# selective list of patches from debian
	epatch \
		"${WORKDIR}"/debian/patches/0000-prequilt-tweaks.patch  \
		"${WORKDIR}"/debian/patches/0002-prototype-rmdir.patch \
		"${WORKDIR}"/debian/patches/0003-struct-init-braces.patch \
		"${WORKDIR}"/debian/patches/0004-man-dash-hyphen-slash.patch
	sed -i -e '/^CC/d' -e '/^CFLAGS/d' src/makefile.u || die
	tc-export CC
}

src_compile() {
	emake -C src -f makefile.u
}

src_install() {
	doman f2c.1
	use doc && dodoc f2c.pdf
	newdoc "${WORKDIR}"/debian/changelog debian.changelog
	cd src
	dobin f2c
	dodoc README Notice
}
