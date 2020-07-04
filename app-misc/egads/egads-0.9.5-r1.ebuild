# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib toolchain-funcs

DESCRIPTION="Entropy Gathering And Distribution System"
HOMEPAGE="http://www.securesoftware.com/download_egads.htm"
SRC_URI="http://www.securesoftware.com/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

EGADS_DATADIR=/var/run/egads

src_prepare() {
	default
	sed -i \
		-e '/^BINDIR/d' \
		-e '/^LIBDIR/d' \
		-e '/^INCLUDEDIR/d' \
		"${S}"/Makefile.in || die "Failed to fix Makefile.in"
	tc-export CC AR RANLIB
}

src_configure() {
	econf \
		--with-egads-datadir="${EGADS_DATADIR}" \
		--with-bindir=/usr/sbin
}

src_compile() {
	emake LIBDIR="/usr/$(get_libdir)"
}

src_install() {
	keepdir ${EGADS_DATADIR}
	fperms +t ${EGADS_DATADIR}
	# NOT parallel safe, and no DESTDIR support
	emake -j1 install \
		BINDIR="${D}"/usr/sbin \
		LIBDIR="${D}"/usr/$(get_libdir) \
		INCLUDEDIR="${D}"/usr/include

	dodoc README* doc/*.txt doc/*.html
}
