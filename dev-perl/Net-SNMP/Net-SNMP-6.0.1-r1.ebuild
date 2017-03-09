# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P=${PN}-v${PV}
S=${WORKDIR}/${MY_P}
MODULE_AUTHOR=DTOWN
inherit perl-module

DESCRIPTION="A SNMP Perl Module"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~ppc-aix ~sparc-solaris ~x86-solaris"
# Package warrants IUSE examples
IUSE=""

RDEPEND="
	>=dev-perl/Crypt-DES-2.03
	>=virtual/perl-Digest-MD5-2.11
	>=dev-perl/Digest-SHA1-1.02
	>=dev-perl/Digest-HMAC-1.0
	>=virtual/perl-libnet-1.0703"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST=do

src_install() {
	perl-module_src_install
	docompress -x usr/share/doc/${PF}/examples
	insinto usr/share/doc/${PF}/
	doins -r examples/
}
