# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} pypy3 )

inherit autotools optfeature python-single-r1 readme.gentoo-r1

DESCRIPTION="A plain text human readable/writable document format"
HOMEPAGE="https://asciidoc.org/ https://github.com/asciidoc/asciidoc-py3/"
SRC_URI="https://github.com/${PN}/${PN}-py3/archive/${PV/_/}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	app-text/docbook-xml-dtd:4.5
	>=app-text/docbook-xsl-stylesheets-1.75
	dev-libs/libxslt
	dev-libs/libxml2:2
	"
DEPEND="
	test? (
		${PYTHON_DEPS}
		app-text/dvipng
		app-text/dvisvgm
		dev-texlive/texlive-latex
		dev-util/source-highlight
		media-gfx/graphviz
		media-gfx/imagemagick
		media-sound/lilypond
	)"

DOC_CONTENTS="
If you are going to use a2x, please also look at a2x(1) under
REQUISITES for a list of runtime dependencies.
"

DOCS=( BUGS.txt CHANGELOG.txt README.asciidoc
	   docbook-xsl/asciidoc-docbook-xsl.txt dblatex/dblatex-readme.txt
	   filters/code/code-filter-readme.txt )

S="${WORKDIR}/${PN}-py3-${PV/_/}"

src_prepare() {
	default
	# Only needed for prefix - harmless (does nothing) otherwise
	sed -i -e "s:^CONF_DIR=.*:CONF_DIR='${EPREFIX}/etc/asciidoc':" \
		asciidoc.py || die

	# enforce usage of the configured version of Python
	sed -i -e "s:python3:${EPYTHON}:" Makefile.in || die

	eautoreconf
}

src_configure() {
	econf --sysconfdir="${EPREFIX}"/usr/share
}

src_install() {
	default

	if use doc; then
		emake DESTDIR="${D}" docs
	fi

	python_fix_shebang "${ED}"/usr/bin/*.py

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	optfeature "\"music\" filter support" "media-sound/lilypond media-gfx/imagemagick"
	optfeature "\"source\" filter support" dev-util/source-highlight dev-python/pygments app-text/highlight
	optfeature "\"latex\" filter support" "dev-texlive/texlive-latex app-text/dvipng" "dev-texlive/texlive-latex app-text/dvisvgm"
	optfeature "\"graphviz\" filter support" media-gfx/graphviz
}
