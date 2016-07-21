# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="File history and comparison tools"
HOMEPAGE="http://fhist.sourceforge.net/fhist.html"
SRC_URI="http://fhist.sourceforge.net/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc x86"
IUSE="test"

RDEPEND="sys-devel/gettext
		sys-apps/groff"
DEPEND="${RDEPEND}
		test? ( app-arch/sharutils )
		sys-devel/bison"

MAKEOPTS+=" -j1"

src_compile() {
	econf
	emake || die "emake failed"
}

src_test() {
	emake sure || die "src_test failed"
}

src_install () {
	emake \
		RPM_BUILD_ROOT="${D}" \
		NLSDIR="${D}/usr/share/locale" \
		install || die "make install failed"

	dodoc lib/en/*.txt || die
	dodoc lib/en/*.ps || die

	# remove duplicate docs etc.
	rm -r "${D}"/usr/share/fhist

	dodoc MANIFEST README || die
}
