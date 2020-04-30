# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic systemd toolchain-funcs

DESCRIPTION="A software watchdog and /dev/watchdog daemon"
HOMEPAGE="https://sourceforge.net/projects/watchdog/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="nfs"

RDEPEND="nfs? ( net-libs/libtirpc )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	if use nfs; then
		append-cppflags "$($(tc-getPKG_CONFIG) libtirpc --cflags)"
		append-libs "$($(tc-getPKG_CONFIG) libtirpc --libs)"
	fi
	econf $(use_enable nfs)
}

src_install() {
	default
	dodoc -r examples

	newconfd "${FILESDIR}"/${PN}-conf.d ${PN}
	newinitd "${FILESDIR}"/${PN}-init.d-r1 ${PN}
	systemd_dounit "${FILESDIR}"/watchdog.service
}
