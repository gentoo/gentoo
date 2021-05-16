# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module

DESCRIPTION="Video::ivtv perl module, for use with ivtv-ptune"
HOMEPAGE="http://ivtv.sourceforge.net"
SRC_URI="mirror://sourceforge/ivtv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	export OPTIMIZE="$CFLAGS"
	perl-module_src_configure
}

# Requires /dev/video0 access, set DIST_TEST_OVERRIDE
# to circumvent
DIST_TEST="skip"

src_test() {
	ebegin "Compile testing Video::ivtv ${PV}"
		perl -Mblib="${S}" -M"Video::ivtv ${PV} ()" -e1
	if ! eend $?; then
		echo
		eerror "One or more modules failed compile:";
		eerror "  Video::ivtv ${PV}"
		die "Failing due to module compilation errors";
	fi
	perl-module_src_test
}
