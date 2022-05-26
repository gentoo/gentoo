# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="CPU, memory, swap, network stats for G15 Keyboard"
HOMEPAGE="https://gitlab.com/menelkir/g15stats"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/menelkir/g15stats.git"
else
	SRC_URI="https://gitlab.com/menelkir/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=app-misc/g15daemon-3.0
	>=dev-libs/libg15-3.0
	>=dev-libs/libg15render-3.0
	sys-libs/zlib
	gnome-base/libgtop
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	export CPPFLAGS="${CFLAGS}"
	econf
}

src_install() {
	default
	rm "${ED}"/usr/share/doc/${PF}/{COPYING,NEWS} || die

	newconfd "${FILESDIR}/${PN}-1.9.7.confd" ${PN}
	newinitd "${FILESDIR}/${PN}-1.9.7.initd-r1" ${PN}
}

pkg_postinst() {
	elog "Remember to set the interface you want monitored in"
	elog "/etc/conf.d/g15stats"
}
