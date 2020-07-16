# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_PN="vlan"

DESCRIPTION="802.1Q vlan control utility"
HOMEPAGE="http://www.candelatech.com/~greear/vlan.html"
SRC_URI="http://www.candelatech.com/~greear/vlan/${MY_PN}.${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ppc ~ppc64 sparc x86"
IUSE="static"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	default
	sed -e "s:/usr/local/bin/vconfig:/sbin/vconfig:g" -i vlan_test.pl || die
	sed -e "s:/usr/local/bin/vconfig:/sbin/vconfig:g" -i vlan_test2.pl || die
}

src_configure() {
	use static && append-ldflags -static
}

src_compile() {
	emake purge
	emake \
		CC="$(tc-getCC)" \
		CCFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		STRIP="true" vconfig
}

src_install() {
	into /
	dosbin vconfig

	local HTML_DOCS=( {howto,vlan}.html )
	einstalldocs
	dodoc vlan_test*.pl

	doman vconfig.8
}

pkg_postinst() {
	ewarn "MTU problems exist for many ethernet drivers."
	ewarn "Reduce the MTU on the interface to 1496 to work around them."
}
