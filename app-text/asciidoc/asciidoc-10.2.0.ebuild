# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
inherit distutils-r1 optfeature readme.gentoo-r1 pypi

DESCRIPTION="A plain text human readable/writable document format"
HOMEPAGE="https://asciidoc.org/ https://github.com/asciidoc-py/asciidoc-py/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="app-text/docbook-xml-dtd:4.5
	>=app-text/docbook-xsl-stylesheets-1.75
	dev-libs/libxslt
	dev-libs/libxml2:2"

DOC_CONTENTS="
If you are going to use a2x, please also look at a2x(1) under
REQUISITES for a list of runtime dependencies.
"

src_install() {
	distutils-r1_src_install

	# TODO: Consider using Debian patch to allow /usr/share?
	insinto /usr/share/asciidoc
	doins -r asciidoc/resources/.

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	optfeature "music filter support" "media-sound/lilypond virtual/imagemagick-tools"
	optfeature "source filter support" "dev-util/source-highlight dev-python/pygments app-text/highlight"
	optfeature "latex filter support" "dev-texlive/texlive-latex app-text/dvipng" "dev-texlive/texlive-latex app-text/dvisvgm"
	optfeature "graphviz filter support" "media-gfx/graphviz"
}
