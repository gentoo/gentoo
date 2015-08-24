# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=HAWK
MODULE_VERSION=0.52

inherit perl-module toolchain-funcs

DESCRIPTION="Perl extension for iptables libiptc library"
SRC_URI="${SRC_URI}
https://dev.gentoo.org/~pinkbyte/distfiles/${PN}/${P}-support-for-iptables-1.4.12.patch.bz2
https://dev.gentoo.org/~pinkbyte/distfiles/${PN}/${P}-support-for-iptables-1.4.16.2.patch.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

# package dependency on iptables is very fragile
# see https://rt.cpan.org/Public/Bug/Display.html?id=70639
RDEPEND="<net-firewall/iptables-1.4.18:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${WORKDIR}/${P}-support-for-iptables-1.4.12.patch"
	"${WORKDIR}/${P}-support-for-iptables-1.4.16.2.patch"
	"${FILESDIR}/${P}-respect-cflags.patch"
)

# Most of tests needs root access, but they do not fail without it
SRC_TEST="do"

src_prepare() {
	tc-export CC
	perl-module_src_prepare
}
