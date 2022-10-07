# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_P=${P/netkit-}

DESCRIPTION="Netkit - bootp"
HOMEPAGE="http://ftp.linux.org.uk/pub/linux/Networking/netboot/"
SRC_URI="http://ftp.linux.org.uk/pub/linux/Networking/netboot/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc ~sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${P}.patch )

src_configure() {
	tc-export CC
}

src_compile() {
	emake linux
}

src_install() {
	dosbin bootp{d,ef,gw,test}

	local x
	for x in d ef gw test; do
		dosym bootp${x} /usr/sbin/in.bootp${x}
	done

	doman *.5 *.8
	dodoc Announce Changes Problems README{,-linux} ToDo
}
