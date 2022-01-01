# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A modern multi-purpose calculator library"
HOMEPAGE="https://qalculate.github.io/"
SRC_URI="https://github.com/Qalculate/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/21"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="curl icu gnuplot readline"

DEPEND="
	dev-libs/gmp:0=
	dev-libs/libxml2:2
	dev-libs/mpfr:0=
	virtual/libiconv
	curl? ( net-misc/curl )
	icu? ( dev-libs/icu:= )
	readline? ( sys-libs/readline:0= )"
RDEPEND="${DEPEND}
	gnuplot? ( >=sci-visualization/gnuplot-3.7 )"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	default

	cat >po/POTFILES.skip <<-EOF || die
		# Required by make check
		data/currencies.xml.in
		data/datasets.xml.in
		data/elements.xml.in
		data/functions.xml.in
		data/planets.xml.in
		data/prefixes.xml.in
		data/units.xml.in
		data/variables.xml.in
		src/defs2doc.cc
	EOF
}

src_configure() {
	econf \
		--disable-static \
		$(use_with curl libcurl) \
		$(use_with gnuplot gnuplot-call) \
		$(use_with icu) \
		$(use_with readline)
}

src_install() {
	# docs/reference/Makefile.am -> referencedir=
	emake \
		DESTDIR="${D}" \
		referencedir="${EPREFIX}/usr/share/doc/${PF}/html" \
		install
	einstalldocs

	find "${ED}" -name '*.la' -delete || die
}
