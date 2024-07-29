# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs flag-o-matic

DESCRIPTION="Entropy Gathering And Distribution System"
HOMEPAGE="http://www.securesoftware.com"
SRC_URI="http://www.securesoftware.com/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

EGADS_DATADIR=/var/run/egads

PATCHES=(
	"${FILESDIR}"/${P}-make-build-work-with-clang16.patch
)

src_prepare() {
	default

	rm aclocal.m4 || die

	eautoreconf

	sed -i \
		-e '/^BINDIR/d' \
		-e '/^LIBDIR/d' \
		-e '/^INCLUDEDIR/d' \
		"${S}"/Makefile.in || die "Failed to fix Makefile.in"
}

src_configure() {
	tc-export CC AR RANLIB

	# bug #312983
	append-flags -fno-strict-aliasing

	econf --with-egads-datadir="${EGADS_DATADIR}"
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

	find "${ED}" -name '*.la' -delete || die
}
