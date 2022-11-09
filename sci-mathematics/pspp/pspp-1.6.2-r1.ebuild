# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit python-any-r1 xdg

DESCRIPTION="Program for statistical analysis of sampled data"
HOMEPAGE="https://www.gnu.org/software/pspp/pspp.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
# Note: can drop test infra + which dep in next release!
IUSE="doc examples gtk ncurses nls perl postgres test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2:2
	sci-libs/gsl:0=
	sys-devel/gettext
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	sys-libs/zlib
	virtual/libiconv
	x11-libs/cairo[svg(+)]
	x11-libs/pango
	gtk? (
		dev-util/glib-utils
		x11-libs/gtk+:3
		x11-libs/gtksourceview:4=
		>=x11-libs/spread-sheet-widget-0.7
	)
	postgres? ( dev-db/postgresql:=[server] )"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

pkg_pretend() {
	ewarn "Starting with pspp-1.4.0 the pspp-mode emacs package is no longer"
	ewarn "shipped with pspp itself, and should instead be fetched from ELPA:"
	ewarn "https://elpa.gnu.org/packages/pspp-mode.html"
}

src_prepare() {
	default

	sed -i '/appdata$/s/appdata$/metainfo/' Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with gtk gui) \
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
