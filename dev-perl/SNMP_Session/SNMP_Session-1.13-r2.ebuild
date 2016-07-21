# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="A SNMP Perl Module"
SRC_URI="https://snmp-session.googlecode.com/files/${P}.tar.gz"
HOMEPAGE="https://github.com/sleinen/snmp-session"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~sparc-solaris ~x86-solaris"

PATCHES=(
	"${FILESDIR}"/${P}-Socket6.patch
)

src_install() {
	perl-module_src_install
	dohtml index.html
}
