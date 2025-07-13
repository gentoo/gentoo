# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs autotools

DESCRIPTION="TCP/IP traffic logger"
HOMEPAGE="https://ojnk.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/ojnk/${P}.tar.gz"

LICENSE="|| ( GPL-2 FDL-1.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc sparc x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-DLT_LINUX_SSL.patch"
	"${FILESDIR}/${P}-C23.patch")

DOCS=( AUTHORS NEWS README TODO example-iplog.conf )

src_prepare() {
	default

	#https://bugs.gentoo.org/899936
	#https://bugs.gentoo.org/875155
	eautoreconf
}

src_compile() {
	append-cppflags -D_REENTRANT
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" CPPFLAGS="${CPPFLAGS}" all
}

src_install() {
	default
	newinitd "${FILESDIR}"/iplog.rc6 iplog
}
