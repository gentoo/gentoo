# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump with sci-calculators/qalculate-gtk and sci-calculators/qalculate-qt

inherit autotools flag-o-matic toolchain-funcs

MY_PV="${PV//b/}"

DESCRIPTION="A modern multi-purpose calculator library"
HOMEPAGE="https://qalculate.github.io/"
SRC_URI="https://github.com/Qalculate/libqalculate/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/"${PN}-${MY_PV}"

LICENSE="GPL-2+"
# SONAME changes pretty often on bumps. Check!
SLOT="0/23.3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+curl icu gnuplot +hardened readline test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/gmp:=
	dev-libs/libxml2:2=
	dev-libs/mpfr:=
	virtual/libiconv
	curl? ( net-misc/curl )
	icu? ( dev-libs/icu:= )
	readline? ( sys-libs/readline:= )"
RDEPEND="${DEPEND}
	gnuplot? ( >=sci-visualization/gnuplot-3.7 )"
BDEPEND="dev-util/intltool
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

	eautoreconf
}

src_configure() {
	# Needed for po-defs/Makefile
	export CXX_FOR_BUILD="$(tc-getBUILD_CXX)"
	export CXXCPP_FOR_BUILD="$(tc-getBUILD_CXX) -E"

	# bug #792027
	tc-export CC

	# bug #924939
	use elibc_musl && append-ldflags -Wl,-z,stack-size=2097152

	local myeconfargs=(
		$(use_enable test tests)
		$(use_enable test unittests)
		$(use_with curl libcurl)
		$(use_with gnuplot gnuplot-call)
		$(use_enable !hardened insecure)
		$(use_with icu)
		$(use_with readline)
	)

	econf "${myeconfargs[@]}"
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
