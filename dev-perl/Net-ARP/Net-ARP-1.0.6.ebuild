# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-ARP/Net-ARP-1.0.6.ebuild,v 1.1 2013/02/27 10:38:20 chainsaw Exp $

EAPI=5

MODULE_AUTHOR=CRAZYDJ
MODULE_VERSION=1.0.6
MODULE_A_EXT=tgz
inherit perl-module

DESCRIPTION="Perl extension for creating ARP packets"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/Net-Pcap"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}
PATCHES=( "${FILESDIR}"/1.0.6-header.diff )

src_prepare() {
	perl -MDevel::PPPort -e 'Devel::PPPort::WriteFile();'
	perl-module_src_prepare
}
