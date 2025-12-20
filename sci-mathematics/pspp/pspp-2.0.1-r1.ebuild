# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit python-any-r1 xdg

DESCRIPTION="Program for statistical analysis of sampled data"
HOMEPAGE="https://www.gnu.org/software/pspp/pspp.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.3+"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples gui ncurses nls perl postgres"

RDEPEND="
	dev-libs/libxml2:2=
	>=sci-libs/gsl-1.13:0=
	sys-libs/readline:0=
	virtual/zlib:=
	virtual/libiconv
	x11-libs/cairo[svg(+)]
	x11-libs/pango
	gui? (
		>=dev-libs/glib-2.44:2
		>=x11-libs/gtk+-3.22.0:3
		>=x11-libs/gtksourceview-4.0:4
		>=x11-libs/spread-sheet-widget-0.7
	)
	postgres? ( dev-db/postgresql:=[server(+)] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( virtual/texi2dvi )
	gui? ( dev-util/glib-utils )
"

pkg_pretend() {
	ewarn "Starting with pspp-1.4.0 the pspp-mode emacs package is no longer"
	ewarn "shipped with pspp itself, and should instead be fetched from ELPA:"
	ewarn "https://elpa.gnu.org/packages/pspp-mode.html"
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with gui) \
		$(use_with perl perl-module) \
		$(use_with postgres libpq)
}

src_compile() {
	default

	if use doc; then
		emake html pdf
		HTML_DOCS=( doc/pspp{,-dev}.html )
	fi
}

src_install() {
	default

	use doc && dodoc doc/pspp{,-dev}.pdf
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	find "${ED}" -name '*.la' -type f -delete || die
}
