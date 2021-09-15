# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P}.k26"

inherit toolchain-funcs

DESCRIPTION="Tool to snoop on login tty's through another tty-device or pseudo-tty"
HOMEPAGE="http://sysd.org/stas/node/35"
SRC_URI="http://sysd.org/stas/files/active/0/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/libcrypt:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/pinkbyte_masking.patch
	"${FILESDIR}"/"${PN}"-makefile.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dodir /var/spool/ttysnoop
	keepdir /var/spool/ttysnoop

	fperms o= /var/spool/ttysnoop

	dosbin ttysnoop ttysnoops

	dodoc README snooptab.dist

	doman ttysnoop.8
	insinto /etc
	newins snooptab.dist snooptab
}
