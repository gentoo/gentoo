# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An OCR (Optical Character Recognition) reader"
HOMEPAGE="http://jocr.sourceforge.net"
SRC_URI="http://www-e.uni-magdeburg.de/jschulen/ocr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc scanner tk"

DEPEND="
	>=media-libs/netpbm-9.12
	doc? (
		>=media-gfx/transfig-3.2
		app-text/ghostscript-gpl
	)
	tk? ( dev-lang/tk )"
RDEPEND="${DEPEND}
	tk? (
		media-gfx/xli
		scanner? ( media-gfx/xsane )
	)"

src_compile() {
	local targets=( src man )
	use doc && targets+=( doc examples )

	emake "${targets[@]}"
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" exec_prefix="${EPREFIX}/usr" install
	einstalldocs
	dodoc HISTORY REMARK.txt REVIEW

	# remove the tk frontend if tk is not selected
	if ! use tk; then
		rm "${ED}"/usr/bin/gocr.tcl || die
	fi

	# and install the documentation and examples
	if use doc; then
		dodoc doc/gocr.html doc/examples.txt doc/unicode.txt

		docinto examples
		dodoc examples/*.{fig,tex,pcx}
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
