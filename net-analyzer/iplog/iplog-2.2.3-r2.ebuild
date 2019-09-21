# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="iplog is a TCP/IP traffic logger"
HOMEPAGE="http://ojnk.sourceforge.net/"
SRC_URI="mirror://sourceforge/ojnk/${P}.tar.gz"

LICENSE="|| ( GPL-2 FDL-1.1 )"
SLOT="0"
KEYWORDS="alpha ~amd64 ~mips ppc sparc x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-DLT_LINUX_SSL.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS} -D_REENTRANT" all
}

src_install() {
	emake \
		prefix="${D}"/usr \
		mandir="${D}"/usr/share/man \
		install

	dodoc AUTHORS NEWS README TODO example-iplog.conf

	newinitd "${FILESDIR}"/iplog.rc6 iplog
}
