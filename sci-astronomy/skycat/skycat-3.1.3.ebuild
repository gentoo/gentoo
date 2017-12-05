# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="ESO astronomical image visualizer with catalog access"
HOMEPAGE="http://archive.eso.org/skycat"
SRC_URI="http://archive.eso.org/cms/tools-documentation/skycat-download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="threads"

DEPEND="
	dev-tcltk/blt:=
	dev-tcltk/expect:=
	dev-tcltk/itcl:=
	dev-tcltk/iwidgets:=
	dev-tcltk/tkimg:=
	sci-astronomy/wcstools:=
	sci-libs/cfitsio:=
	x11-libs/libXext:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.3-string-issues.patch
	"${FILESDIR}"/${PN}-3.1.3-remove-tclx-dep.patch
	"${FILESDIR}"/${PN}-3.1.2-m4.patch
	"${FILESDIR}"/${PN}-3.1.2-makefile-qa.patch
	"${FILESDIR}"/${PN}-3.0.2-systemlibs.patch
	"${FILESDIR}"/${PN}-3.0.2-tk8.5.patch
)

src_prepare() {
	default
	rm -r astrotcl/{cfitsio,libwcs} || die
	# prefix it
	sed -e "s:/usr:${EPREFIX}/usr:g" \
		-i */configure.in */aclocal.m4 || die
	local f
	for f in configure.in */configure.in ; do
		mv "$f" "${f/.in/.ac}" || die
	done
	# bug #626162 . lazy sed to avoid a big patch
	sed -i -e 's/static char/static unsigned char/g' $(find . -name \*.xbm) || die
	eautoreconf
}

src_configure() {
	# bug #514604
	append-cppflags -DUSE_INTERP_RESULT
	econf $(use_enable threads) --enable-merge
}

src_install() {
	default
	local d f
	for d in tclutil astrotcl rtd cat skycat; do
		for f in README CHANGES VERSION; do
			newdoc ${f} ${f}.${d}
		done
	done
}
