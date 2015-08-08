# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit systemd toolchain-funcs

DESCRIPTION="simple & stable nscd replacement"
HOMEPAGE="http://busybox.net/~vda/unscd/README"
SRC_URI="http://busybox.net/~vda/unscd/nscd-${PV}.c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-libs/glibc[nscd(+)]"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/nscd-${PV}.c ${PN}.c || die
}

src_compile() {
	tc-export CC
	emake unscd
}

src_install() {
	newinitd "${FILESDIR}"/unscd.initd-r1 unscd
	systemd_newtmpfilesd "${FILESDIR}"/unscd-tmpfiles.conf unscd.conf
	systemd_dounit "${FILESDIR}"/unscd.service
	dosbin unscd
}
