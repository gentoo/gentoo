# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CRAZYDJ
DIST_VERSION=1.0.11
DIST_A_EXT=tgz
DIST_WIKI="tests"
inherit perl-module

DESCRIPTION="Perl extension for creating ARP packets"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/Net-Pcap"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/1.0.9-header.diff"
	"${FILESDIR}/${PN}-1.0.9-perl-5.26.patch"
)

src_prepare() {
	if [[ -z $TEST_ARP_IF ]]; then
		perl_rm_files t/send_packet.t
	fi
	perl -MDevel::PPPort -e 'Devel::PPPort::WriteFile();'
	perl-module_src_prepare
}
