# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TIMPOTTER
DIST_VERSION=0.01
inherit perl-module

DESCRIPTION="Utility routines for use with Net::Pcap"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-perl/Net-Pcap"
DEPEND="${RDEPEND}"
PATCHES=("${FILESDIR}/${PN}-0.01-testsuite.patch")

src_test() {
	if [[ $EUID != 0 ]]; then
		elog "Some tests require root privileges. For details, see:"
		elog "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	fi
	perl-module_src_test
}
