# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit python-single-r1

DESCRIPTION="AsciiDoc is a plain text human readable/writable document format"
HOMEPAGE="http://asciidoc.org/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples graphviz highlight test vim-syntax"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=app-text/docbook-xsl-stylesheets-1.75
		dev-libs/libxslt
		graphviz? ( media-gfx/graphviz )
		app-text/docbook-xml-dtd:4.5
		app-text/dblatex
		|| ( www-client/w3m www-client/lynx )
		highlight? ( || ( dev-util/source-highlight \
			dev-python/pygments[${PYTHON_USEDEP}] \
			app-text/highlight )
		)
		${PYTHON_DEPS}
"
DEPEND="test? ( dev-util/source-highlight
			media-sound/lilypond
			media-gfx/imagemagick
			dev-texlive/texlive-latex
			app-text/dvipng
			media-gfx/graphviz
			${PYTHON_DEPS} )
"

src_prepare() {
	if ! use vim-syntax; then
		sed -i -e '/^install/s/install-vim//' Makefile.in || die
	else
		sed -i\
			-e "/^vimdir/s:@sysconfdir@/vim:${EPREFIX}/usr/share/vim/vimfiles:" \
			-e 's:/etc/vim::' \
			Makefile.in || die
	fi

	# Only needed for prefix - harmless (does nothing) otherwise
	sed -i -e "s:^CONF_DIR=.*:CONF_DIR='${EPREFIX}/etc/asciidoc':" \
		"${S}/asciidoc.py" || die
}

src_configure() {
	econf --sysconfdir="${EPREFIX}"/usr/share
}

src_install() {
	use vim-syntax && dodir /usr/share/vim/vimfiles

	emake DESTDIR="${D}" install

	python_fix_shebang "${ED}"/usr/bin/*.py

	dodoc BUGS CHANGELOG README docbook-xsl/asciidoc-docbook-xsl.txt \
			dblatex/dblatex-readme.txt filters/code/code-filter-readme.txt

	# Below results in some files being installed twice in different locations, but they are in the right place,
	# uncompressed, and there won't be any broken links. See bug #483336.
	if use examples; then
		cp -rL examples/website "${D}"/usr/share/doc/${PF}/examples || die
	fi
	docompress -x /usr/share/doc/${PF}/examples
}

src_test() {
	cd tests || die
	local -x ASCIIDOC_PY=../asciidoc.py
	"${PYTHON}" test${PN}.py update || die
	"${PYTHON}" test${PN}.py run || die
}
