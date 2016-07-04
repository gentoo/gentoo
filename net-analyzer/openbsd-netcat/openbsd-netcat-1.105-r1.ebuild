# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="The OpenBSD network swiss army knife"
HOMEPAGE="http://www.openbsd.org/cgi-bin/cvsweb/src/usr.bin/nc/"
SRC_URI="http://http.debian.net/debian/pool/main/n/netcat-openbsd/netcat-openbsd_${PV}.orig.tar.gz
	http://http.debian.net/debian/pool/main/n/netcat-openbsd/netcat-openbsd_${PV}-7.debian.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE="elibc_Darwin"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x64-macos"

DEPEND="virtual/pkgconfig"
RDEPEND="!elibc_Darwin? ( dev-libs/libbsd )
	!net-analyzer/netcat
	!net-analyzer/netcat6
"

S=${WORKDIR}/netcat-openbsd-${PV}

PATCHES=( "${WORKDIR}/debian/patches" )

src_prepare() {
	default
	if [[ ${CHOST} == *-darwin* ]] ; then
		# Darwin = BSD, so remove libbsd dependency
		sed -i -e '/#include/s|bsd/||' -e 's/strtonum/strtoimax/' *.[ch] || die
		# Clang defaults to C99, but strtoimax isn't in C99
		append-flags -DIPTOS_LOWCOST=0x02 -std=c89
	fi
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin nc
	doman nc.1
	cd "${WORKDIR}/debian"
	newdoc netcat-openbsd.README.Debian README
	dodoc -r examples
}

pkg_postinst() {
	if [[ ${KERNEL} = "linux" ]]; then
		ewarn "FO_REUSEPORT is introduced in linux 3.9. If your running kernel is older"
		ewarn "and kernel header is newer, nc will not listen correctly. Matching the header"
		ewarn "to the running kernel will do. See bug #490246 for details."
	fi
}
