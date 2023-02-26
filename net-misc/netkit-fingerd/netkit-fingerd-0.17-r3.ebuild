# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Netkit - fingerd and finger client"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/netkit"
SRC_URI="http://ftp.linux.org.uk/pub/linux/Networking/finger/bsd-finger-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE=""

S=${WORKDIR}/bsd-finger-${PV}

PATCHES=(
	"${FILESDIR}"/netkit-fingerd-0.17-includes.patch
	"${FILESDIR}"/${P}-name-check.patch #80286
)

src_configure() {
	# We'll skip this stage as the configure script is crappy and not really
	# needed -- src_install installs all files by hand.
	touch MCONFIG
	tc-export CC
}

src_compile() {
	emake CC="${CC}"
}

src_install() {
	dobin finger/finger
	dosbin fingerd/fingerd
	dosym fingerd /usr/sbin/in.fingerd
	doman finger/finger.1 fingerd/fingerd.8
	dosym fingerd.8 /usr/share/man/man8/in.fingerd.8
	dodoc README ChangeLog BUGS

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/fingerd.xinetd fingerd
}
