# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Convert HTML pages into a PDF document"
HOMEPAGE="http://www.msweet.org/projects.php?Z1"
SRC_URI="https://github.com/michaelrsweet/${PN}/releases/download/v${PV}/${P}-source.tar.gz"
IUSE="fltk"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND=">=media-libs/libpng-1.4:0=
	virtual/jpeg:0
	fltk? ( x11-libs/fltk:1 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare() {
	default

	# make sure not to use the libs htmldoc ships with
	rm -r jpeg png zlib || die 'failed to unbundle jpeg, png, and zlib'

	# Fix the documentation path in a few places. Some Makefiles aren't
	# autotoolized =(
	for file in configure doc/Makefile doc/htmldoc.man; do
		sed -i "${file}" \
			-e "s:/doc/htmldoc:/doc/${PF}/html:g" \
			|| die "failed to fix documentation path in ${file}"
	done
}

src_configure() {
	CC=$(tc-getCC) CXX=$(tc-getCXX)	DSTROOT="${D}" econf $(use_with fltk gui)
}

src_install() {
	emake DSTROOT="${D}" install
}
