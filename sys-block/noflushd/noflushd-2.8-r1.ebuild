# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A daemon to spin down your disks and force accesses to be cached"
HOMEPAGE="http://noflushd.sourceforge.net/"
SRC_URI="mirror://sourceforge/noflushd/${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

src_configure() {
	econf \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-initdir="${EPREFIX}"/etc/init.d
}

src_install() {
	default

	newinitd "${FILESDIR}"/noflushd.rc6 noflushd
	newconfd "${FILESDIR}"/noflushd.confd noflushd
}

pkg_postinst() {
	ewarn "noflushd works with IDE devices only."
	ewarn "It has possible problems with reiserfs, too."
}
