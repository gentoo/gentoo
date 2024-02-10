# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Console Progress Bar"
HOMEPAGE="http://clpbar.sourceforge.net/"
SRC_URI="mirror://sourceforge/clpbar/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc"

DEPEND="doc? ( >=app-text/doxygen-1.3.5 )"
RDEPEND=""

src_prepare() {
	default
	sed '/cd $(WEB_DIR) && $(MAKE)/d' -i Makefile.am || die
	eautomake
}

src_configure() {
	# Fix bug 113392
	econf $(use_enable !sparc use-memalign)
}

src_compile() {
	emake CFLAGS="${CFLAGS}"

	if use doc; then
		mkdir -p ../www/doxygen/${PV} || die
		emake update-www
		HTML_DOCS=( ../www/doxygen/${PV}/html/. )

		# remove doxygen working files
		find ../www/doxygen/${PV}/html \( -iname '*.map' -o -iname '*.md5' \) -delete || die
	fi
}

src_install() {
	default
	dodoc TROUBLESHOOTING debian/changelog
}
