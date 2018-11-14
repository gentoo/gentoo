# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="User-space implementation of L2TP for Linux and other UNIX systems"
HOMEPAGE="https://sourceforge.net/projects/rp-l2tp/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"

PATCHES=(
	"${FILESDIR}/${P}-gentoo.patch"
	"${FILESDIR}/${P}-flags.patch"
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-parallel-build.patch"
)

src_prepare() {
	tc-export AR CC RANLIB
	default
}

src_install() {
	emake RPM_INSTALL_ROOT="${D}" install

	einstalldocs
	newdoc l2tp.conf rp-l2tpd.conf
	docinto libevent
	dodoc libevent/Doc/*
	docompress -x "/usr/share/doc/${PF}/libevent"

	newinitd "${FILESDIR}/rp-l2tpd-init" rp-l2tpd
}
