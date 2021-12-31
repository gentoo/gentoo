# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} pypy3 )

inherit autotools eutils python-single-r1 readme.gentoo-r1

DESCRIPTION="A plain text human readable/writable document format"
HOMEPAGE="http://asciidoc.org/ https://github.com/asciidoc/asciidoc-py3/"
SRC_URI="https://github.com/${PN}/${PN}-py3/archive/9.0.0rc1.tar.gz -> ${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
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

S="${WORKDIR}/${PN}-py3-9.0.0rc1"

src_prepare() {
	default
	# Only needed for prefix - harmless (does nothing) otherwise
	sed -i -e "s:^CONF_DIR=.*:CONF_DIR='${EPREFIX}/etc/asciidoc':" \
		"${S}/asciidoc.py" || die

	eautoreconf
}

src_configure() {
	econf --sysconfdir="${EPREFIX}"/usr/share
}

src_test() {
	local -x ASCIIDOC_PY=asciidoc.py
	"${EPYTHON}" tests/test${PN}.py run || die
}

src_install() {
	default
	python_fix_shebang "${ED}"/usr/bin/*.py

	readme.gentoo_create_doc

	# Below results in some files being installed twice in different locations, but they are
	# in the right place, uncompressed, and there won't be any broken links. See bug #483336
	if use examples; then
		# examples/website is full of relative symlinks,
		# deref them for copying, which dodoc doesn't do
		cp -rL examples/website "${ED}"/usr/share/doc/${PF}/examples || die
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	readme.gentoo_print_elog

	optfeature "\"music\" filter support" "media-sound/lilypond media-gfx/imagemagick"
	optfeature "\"source\" filter support" dev-util/source-highlight dev-python/pygments app-text/highlight
	optfeature "\"latex\" filter support" "dev-texlive/texlive-latex app-text/dvipng" "dev-texlive/texlive-latex app-text/dvisvgm"
	optfeature "\"graphviz\" filter support" media-gfx/graphviz
}
