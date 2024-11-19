# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="0.01"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="dock-app showing you status of your XName hosted zones"
HOMEPAGE="http://source.xname.org/"
SRC_URI="http://source.xname.org/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

COMMON_DEPEND=">=x11-libs/libXpm-3.5.7
	>=x11-libs/libX11-1.1.4
	>=x11-libs/libXext-1.0.3"

RDEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5.8.8-r5
	>=www-client/lynx-2.8.6-r2"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default
	#some magic sed to fix CFLAGS
	sed -i "s/-O2 -Wall/$CFLAGS/" "${S}/Makefile" || die

	#INSTALL file actually contains use instructions
	mv "${S}/INSTALL" "${S}/README" || die
}

src_compile() {
	emake CC="$(tc-getCC)" SYSTEM="${LDFLAGS}"
}

src_install() {
	dobin wmXName GrabXName
	dodoc README config.sample
}
