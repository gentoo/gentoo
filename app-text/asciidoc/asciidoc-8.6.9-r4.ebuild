# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 pypy )

inherit python-r1 readme.gentoo-r1

DESCRIPTION="AsciiDoc is a plain text human readable/writable document format"
HOMEPAGE="http://asciidoc.org/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

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
			app-text/highlight
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-util/source-highlight
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
	python_copy_sources
}

src_configure() {
	myconfigure() {
		econf --sysconfdir="${EPREFIX}"/usr/share
	}
	python_foreach_impl run_in_build_dir myconfigure
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_test() {
	mytest() {
		local -x ASCIIDOC_PY=asciidoc.py
		"${EPYTHON}" tests/test${PN}.py update || die
		"${EPYTHON}" tests/test${PN}.py run || die
	}
	python_foreach_impl run_in_build_dir mytest
}

src_install() {
	python_foreach_impl run_in_build_dir default
	python_replicate_script "${ED%/}"/usr/bin/*.py

	readme.gentoo_create_doc
	dodoc CHANGELOG docbook-xsl/asciidoc-docbook-xsl.txt \
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
