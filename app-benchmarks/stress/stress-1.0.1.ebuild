# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/stress/stress-1.0.1.ebuild,v 1.7 2015/02/22 12:43:47 mgorny Exp $

inherit autotools flag-o-matic

MY_P="${PN}-${PV/_/}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Imposes stressful loads on different aspects of the system"
HOMEPAGE="http://people.seas.harvard.edu/~apw/stress"
SRC_URI="http://weather.ou.edu/~apw/projects/stress/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc ppc64 sparc x86"
IUSE="static"

DEPEND="sys-apps/help2man"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Force rebuild of the manpage.
	rm -f doc/stress.1

	# Honour Gentoo CFLAGS.
	sed -i -e "/CFLAGS/s/-Werror//" \
		   -e "s/CFLAGS/AM_CFLAGS/" \
		   src/Makefile.am || die "sed cflags failed"

	eautoreconf
}

src_compile() {
	use static && append-ldflags -static
	econf
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog AUTHORS README
}
