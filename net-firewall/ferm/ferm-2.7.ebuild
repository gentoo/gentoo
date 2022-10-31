# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Command line util for managing firewall rules"
HOMEPAGE="http://ferm.foo-projects.org/"
SRC_URI="http://ferm.foo-projects.org/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

# Uses Internet connection while testing.
RESTRICT="test"

# does not install any perl libs
RDEPEND="dev-lang/perl:*
	net-firewall/iptables
	virtual/perl-File-Spec"

DOCS=( AUTHORS NEWS README.rst TODO doc/ferm.txt examples/ )
HTML_DOCS=( doc/ferm.html )

src_install() {
	dosbin src/{,import-}ferm
	systemd_dounit ferm.service

	einstalldocs
	doman doc/*.1
}

pkg_postinst() {
	elog "See ${EROOT}/usr/share/doc/${PF}/examples for sample configs"
}
