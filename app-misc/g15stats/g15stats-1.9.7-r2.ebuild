# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="CPU, memory, swap, network stats for G15 Keyboard"
HOMEPAGE="https://sourceforge.net/projects/g15daemon/"
SRC_URI="mirror://sourceforge/g15daemon/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-misc/g15daemon-1.9.0
	dev-libs/libg15
	dev-libs/libg15render
	sys-libs/zlib
	gnome-base/libgtop"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-docdir.patch" )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	export CPPFLAGS="${CFLAGS}"
	econf
}

src_install() {
	default
	rm "${D}"/usr/share/doc/${PF}/{COPYING,NEWS} || die

	newconfd "${FILESDIR}/${PN}-1.9.7.confd" ${PN}
	newinitd "${FILESDIR}/${PN}-1.9.7.initd-r1" ${PN}
}

pkg_postinst() {
	elog "Remember to set the interface you want monitored in"
	elog "/etc/conf.d/g15stats"
}
