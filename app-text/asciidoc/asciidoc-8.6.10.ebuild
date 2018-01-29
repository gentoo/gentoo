# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 pypy )

inherit autotools python-single-r1 readme.gentoo-r1

DESCRIPTION="AsciiDoc is a plain text human readable/writable document format"
HOMEPAGE="http://asciidoc.org/"
SRC_URI="https://github.com/asciidoc/asciidoc/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples graphviz highlight test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	app-text/docbook-xml-dtd:4.5
	>=app-text/docbook-xsl-stylesheets-1.75
	dev-libs/libxslt
	${PYTHON_DEPS}
	graphviz? ( media-gfx/graphviz )
	highlight? (
		|| (
			dev-util/source-highlight
			dev-python/pygments[${PYTHON_USEDEP}]
			app-text/highlight
		)
	)"
DEPEND="
	test? (
		app-text/dvipng
		dev-texlive/texlive-latex
		dev-util/source-highlight
		media-gfx/graphviz
		media-gfx/imagemagick
		media-sound/lilypond
		${PYTHON_DEPS}
	)"

DOC_CONTENTS="
If you are going to use a2x, please also look at a2x(1) under
REQUISITES for a list of runtime dependencies.
"

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
	"${EPYTHON}" tests/test${PN}.py update || die
	"${EPYTHON}" tests/test${PN}.py run || die
}

src_install() {
	default
	python_fix_shebang "${ED%/}"/usr/bin/*.py

	readme.gentoo_create_doc
	dodoc BUGS.txt CHANGELOG.txt README.asciidoc docbook-xsl/asciidoc-docbook-xsl.txt \
		dblatex/dblatex-readme.txt filters/code/code-filter-readme.txt

	# Below results in some files being installed twice in different locations, but they are
	# in the right place, uncompressed, and there won't be any broken links. See bug #483336
	if use examples; then
		# examples/website is full of relative symlinks,
		# deref them for copying, which dodoc doesn't do
		cp -rL examples/website "${ED%/}"/usr/share/doc/${PF}/examples || die
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	readme.gentoo_print_elog
}
