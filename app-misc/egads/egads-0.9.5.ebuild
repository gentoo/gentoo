# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib toolchain-funcs

DESCRIPTION="Entropy Gathering And Distribution System"
HOMEPAGE="http://www.securesoftware.com/download_${PN}.htm"
SRC_URI="http://www.securesoftware.com/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

egadsdatadir=/var/run/egads

src_unpack() {
	unpack ${A}
	sed -i \
		-e '/^BINDIR/d' \
		-e '/^LIBDIR/d' \
		-e '/^INCLUDEDIR/d' \
		"${S}"/Makefile.in || die "Failed to fix Makefile.in"
	tc-export CC AR RANLIB
}

src_compile() {
	econf \
		--with-egads-datadir="${egadsdatadir}" \
		--with-bindir=/usr/sbin \
		|| die
	emake LIBDIR="/usr/$(get_libdir)" || die
}

src_install() {
	keepdir ${egadsdatadir}
	fperms +t ${egadsdatadir}
	# NOT parallel safe, and no DESTDIR support
	emake -j1 install \
		BINDIR="${D}"/usr/sbin \
		LIBDIR="${D}"/usr/$(get_libdir) \
		INCLUDEDIR="${D}"/usr/include \
		|| die
	dodoc README* doc/*.txt
	dohtml doc/*.html
}
