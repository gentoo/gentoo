# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Issue-tracking system with command-line, web, and e-mail interfaces"
HOMEPAGE="https://roundup.sourceforge.io https://pypi.org/project/roundup/"

LICENSE="MIT ZPL"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="+tz sqlite mysql postgres xapian whoosh ssl jinja pyjwt markdown"

RDEPEND="
	jinja? ( dev-python/jinja[$PYTHON_USEDEP] )
	markdown? (
		|| (
			dev-python/markdown[$PYTHON_USEDEP]
			dev-python/markdown2[$PYTHON_USEDEP]
			dev-python/mistune[$PYTHON_USEDEP]
		)
	)
	mysql? ( dev-python/mysqlclient[$PYTHON_USEDEP] )
	postgres? ( >=dev-python/psycopg-2.8:2[$PYTHON_USEDEP] )
	pyjwt? ( dev-python/pyjwt[$PYTHON_USEDEP] )
	sqlite? ( $(python_gen_impl_dep sqlite) )
	ssl? ( dev-python/pyopenssl[$PYTHON_USEDEP] )
	tz? ( dev-python/pytz[$PYTHON_USEDEP] )
	whoosh? ( >=dev-python/whoosh-2.5.7[$PYTHON_USEDEP] )
	xapian? ( >=dev-libs/xapian-bindings-1.0.0[python,$PYTHON_USEDEP] )
"

DOCS="CHANGES.txt doc/*.txt"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# this test fails (for both py3.10 and py3.11, and it also fails in 2.1.0)
	# upstream report https://issues.roundup-tracker.org/issue2551272
	test/test_templating.py::Markdown2TestCase::test_string_markdown_code_block_attribute
)

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}"/usr/share/doc/${PN}/html "${ED}"/usr/share/doc/${PF}/ || die
	rmdir "${ED}"/usr/share/doc/${PN} || die
}

pkg_postinst() {
	ewarn "See installation.txt for initialisation instructions."
	ewarn "See upgrading.txt for upgrading instructions."
}
