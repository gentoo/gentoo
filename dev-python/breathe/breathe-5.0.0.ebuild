# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Sphinx Doxygen renderer"
HOMEPAGE="
	https://breathe.readthedocs.io/en/latest/
	https://github.com/breathe-doc/breathe/
	https://pypi.org/project/breathe/
"
SRC_URI="
	https://github.com/breathe-doc/breathe/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
# need doxygen bump for tests?
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	app-text/doxygen
	dev-python/docutils[${PYTHON_USEDEP}]
	>=dev-python/sphinx-7.2.0[${PYTHON_USEDEP}]
	dev-texlive/texlive-bibtexextra
	dev-texlive/texlive-fontsextra
	dev-texlive/texlive-fontutils
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_configure_all() {
	# normally called via setuptools_builder.py
	# (with pointless dep on setuptools)
	"${EPYTHON}" - <<-EOF || die
		import xml_parser_generator.make_parser as mp

		mp.generate_from_json(
			"xml_parser_generator/schema.json",
			[
				(
					"xml_parser_generator/module_template.py.in",
					"breathe/_parser.py"
				)
			]
		)
	EOF
}
