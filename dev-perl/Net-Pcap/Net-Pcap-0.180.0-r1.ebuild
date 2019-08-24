# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SAPER
DIST_VERSION=0.18
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="Interface to the pcap(3) LBL packet capture library"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="net-libs/libpcap
	dev-perl/IO-Interface"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-${DIST_VERSION}-libpcap-1.9.0.patch"
	"${FILESDIR}/${PN}-${DIST_VERSION}-test-error.patch"
)

src_test() {
	if [[ $EUID != 0 ]]; then
		elog "Comprehensive testing of this module requires root permissions."
		elog "For details, see:"
		elog "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	fi
	perl_rm_files t/pod{,cover,spell}.t t/distchk.t t/portfs.t
	perl-module_src_test
}
