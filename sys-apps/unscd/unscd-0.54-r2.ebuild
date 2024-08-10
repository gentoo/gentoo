# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs tmpfiles

DESCRIPTION="simple & stable nscd replacement"
HOMEPAGE="https://busybox.net/~vda/unscd/README"
SRC_URI="https://busybox.net/~vda/unscd/nscd-${PV}.c -> nscd-${PV}-r1.c"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/glibc[nscd(+)]"
DEPEND="${RDEPEND}"

src_unpack() {
	cp "${DISTDIR}"/nscd-${PV}-r1.c unscd.c || die
}

src_compile() {
	tc-export CC
	emake unscd
}

src_install() {
	newinitd "${FILESDIR}"/unscd.initd-r1 unscd
	newtmpfiles "${FILESDIR}"/unscd-tmpfiles.conf unscd.conf
	systemd_dounit "${FILESDIR}"/unscd.service
	dosbin unscd
}

pkg_postinst() {
	tmpfiles_process unscd.conf
}
