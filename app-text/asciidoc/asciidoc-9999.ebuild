# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

[ "$PV" == "9999" ] && inherit mercurial autotools
inherit python-single-r1

DESCRIPTION="AsciiDoc is a plain text human readable/writable document format"
HOMEPAGE="http://www.methods.co.nz/asciidoc/"
if [ "$PV" == "9999" ]; then
	EHG_REPO_URI="https://asciidoc.googlecode.com/hg/"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="examples graphviz highlight test vim-syntax"

REQUIRED_USE="highlight? ( ${PYTHON_REQUIRED_USE} )"

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

if [ "$PV" == "9999" ]; then
	DEPEND="${DEPEND}
		dev-util/aap
		www-client/lynx
		dev-util/source-highlight"
fi

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

	[ "$PV" == "9999" ] && eautoconf
}

src_configure() {
	econf --sysconfdir="${EPREFIX}"/usr/share
}

src_compile() {
	default

	if [ "$PV" == "9999" ]; then
		cd doc || die
		aap -f main.aap ../{CHANGELOG,README,BUGS} || die
	fi
}

src_install() {
	use vim-syntax && dodir /usr/share/vim/vimfiles

	emake DESTDIR="${D}" install

	python_fix_shebang "${ED}"/usr/bin/*.py

	if use examples; then
		# This is a symlink to a directory
		rm examples/website/images || die

		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
		dosym ../../../asciidoc/images /usr/share/doc/${PF}/examples
	fi

	dodoc BUGS CHANGELOG README docbook-xsl/asciidoc-docbook-xsl.txt \
			dblatex/dblatex-readme.txt filters/code/code-filter-readme.txt
}

src_test() {
	cd tests || die
	local -x ASCIIDOC_PY=../asciidoc.py
	"${PYTHON}" test${PN}.py update || die
	"${PYTHON}" test${PN}.py run || die
}
