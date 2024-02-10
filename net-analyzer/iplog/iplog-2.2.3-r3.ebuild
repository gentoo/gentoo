# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="TCP/IP traffic logger"
HOMEPAGE="https://ojnk.sourceforge.net/"
SRC_URI="mirror://sourceforge/ojnk/${P}.tar.gz"

LICENSE="|| ( GPL-2 FDL-1.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc sparc x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PV}-DLT_LINUX_SSL.patch )

DOCS=( AUTHORS NEWS README TODO example-iplog.conf )

src_compile() {
	append-cppflags -D_REENTRANT
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" CPPFLAGS="${CPPFLAGS}" all
}

src_install() {
	default
	newinitd "${FILESDIR}"/iplog.rc6 iplog
}
