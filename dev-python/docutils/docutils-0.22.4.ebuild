# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Python Documentation Utilities (reference reStructuredText impl.)"
HOMEPAGE="
	https://docutils.sourceforge.io/
	https://pypi.org/project/docutils/
"

# GPL-3+ only for emacs/rst.el
LICENSE="BSD BSD-2 GPL-3+ PSF-2.4 public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

python_compile_all() {
	# Generate html docs from reStructured text sources.

	# Place html4css1.css in base directory to ensure that the generated reference to it is correct.
	cp docutils/writers/html4css1/html4css1.css . || die

	cd tools || die
	"${EPYTHON}" buildhtml.py --input-encoding=utf-8 --no-datestamp \
		--stylesheet-path=../html4css1.css, --traceback ../docs || die
}

src_test() {
	cd test || die
	distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" alltests.py -v || die "Testing failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	# Install tools.
	python_doscript tools/buildhtml.py
}

python_install_all() {
	local DOCS=( *.rst )
	local HTML_DOCS=( docs tools docutils/writers/html4css1/html4css1.css )

	distutils-r1_python_install_all
}
