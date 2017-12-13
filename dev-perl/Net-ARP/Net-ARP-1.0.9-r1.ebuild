# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CRAZYDJ
DIST_VERSION=1.0.9
DIST_A_EXT=tgz
inherit perl-module

DESCRIPTION="Perl extension for creating ARP packets"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/Net-Pcap"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/1.0.9-header.diff"
	"${FILESDIR}/${PN}-1.0.9-perl-5.26.patch"
	"${FILESDIR}/${PN}-1.0.9-tests.patch"
)

src_prepare() {
	perl -MDevel::PPPort -e 'Devel::PPPort::WriteFile();'
	perl-module_src_prepare
}

src_test() {
	if [[ $EUID != 0 || -z $TEST_ARP_IF ]]; then
		elog "Comprehensive testing needs additional configuration (and root)."
		elog "For details, see:"
		elog "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	fi
	perl-module_src_test
}
