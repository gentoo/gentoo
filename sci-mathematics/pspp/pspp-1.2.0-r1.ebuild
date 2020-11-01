# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit elisp-common python-any-r1 xdg-utils

DESCRIPTION="Program for statistical analysis of sampled data"
HOMEPAGE="https://www.gnu.org/software/pspp/pspp.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="cairo doc emacs examples gtk ncurses nls perl postgres test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( cairo )"

RDEPEND="
	dev-libs/libxml2:2
	sci-libs/gsl:0=
	sys-devel/gettext
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	sys-libs/zlib
	virtual/libiconv
	cairo? (
		x11-libs/cairo[svg]
		x11-libs/pango
	)
	emacs? ( >=app-editors/emacs-23.1:* )
	gtk? (
		x11-libs/gtk+:3
		x11-libs/gtksourceview:3.0=
		x11-libs/spread-sheet-widget
		cairo? ( dev-util/glib-utils )
	)
	postgres? ( dev-db/postgresql:=[server] )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( virtual/latex-base )
	test? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}"/${P}-CVE-2018-20230.patch
	"${FILESDIR}"/${P}-CVE-2019-9211.patch
	"${FILESDIR}"/${P}-fix-overflow.patch
	"${FILESDIR}"/${P}-fix-segfaults.patch
	"${FILESDIR}"/${P}-fix-gcc10.patch
	"${FILESDIR}"/${P}-py3.patch
	"${FILESDIR}"/${P}-fix-tests.patch
)

SITEFILE=50${PN}-gentoo.el

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	sed -i '/appdata$/s/appdata$/metainfo/' Makefile.in || die
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable nls) \
		$(use_with cairo) \
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
	use emacs && elisp-compile *.el
}

src_install() {
	default

	use doc && dodoc doc/pspp{,-dev}.pdf
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	if use emacs; then
		elisp-install ${PN} *.el *.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	find "${D}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
	use emacs && elisp-site-regen
}

pkg_postrm() {
	xdg_icon_cache_update
	use emacs && elisp-site-regen
}
