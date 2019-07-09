# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A modern multi-purpose calculator library"
HOMEPAGE="https://qalculate.github.io/"
SRC_URI="https://github.com/Qalculate/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/6"
KEYWORDS="alpha amd64 ~arm arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="gnuplot readline static-libs"

COMMON_DEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:2
	>=sci-libs/cln-1.2
	sys-libs/zlib
	readline? ( sys-libs/readline:0= )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	net-misc/wget
	gnuplot? ( >=sci-visualization/gnuplot-3.7 )"

PATCHES=(
	# https://github.com/Qalculate/libqalculate/issues/6
	"${FILESDIR}"/${P}-readline.patch
)

src_prepare() {
	default

	cat >po/POTFILES.skip <<-EOF
	# Required by make check
	data/currencies.xml.in
	data/datasets.xml.in
	data/elements.xml.in
	data/functions.xml.in
	data/planets.xml.in
	data/units.xml.in
	data/variables.xml.in
	src/defs2doc.cc
	EOF
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with readline)
}

src_install() {
	# docs/reference/Makefile.am -> referencedir=
	emake \
		DESTDIR="${D}" \
		referencedir="${EPREFIX}/usr/share/doc/${PF}/html" \
		install

	dodoc AUTHORS ChangeLog NEWS README* TODO

	find "${ED}" -name '*.la' -delete || die
}
