# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/ferm/ferm-2.2.ebuild,v 1.4 2015/01/28 10:18:18 ago Exp $

EAPI=5

inherit versionator systemd

MY_PV="$(get_version_component_range 1-2)"

DESCRIPTION="Command line util for managing firewall rules"
HOMEPAGE="http://ferm.foo-projects.org/"
SRC_URI="http://ferm.foo-projects.org/download/${MY_PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

# does not install any perl libs
RDEPEND="dev-lang/perl:*
	net-firewall/iptables
	virtual/perl-File-Spec"

src_compile() { :; }

src_install () {
	dobin src/{,import-}ferm
	dodoc -r AUTHORS NEWS README TODO doc/*.txt examples
	doman doc/*.1
	dohtml doc/*.html

	systemd_dounit ferm.service
}

pkg_postinst() {
	elog "See /usr/share/doc/${PF}/examples for sample configs"
}
