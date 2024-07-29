# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Issue-tracking system with command-line, web, and e-mail interfaces"
HOMEPAGE="https://roundup.sourceforge.io https://pypi.org/project/roundup/"

LICENSE="MIT ZPL"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="+tz sqlite mysql postgres xapian whoosh ssl jinja pyjwt markdown test"

RDEPEND="
	jinja? ( dev-python/jinja[${PYTHON_USEDEP}] )
	markdown? (
		|| (
			dev-python/markdown[${PYTHON_USEDEP}]
			dev-python/markdown2[${PYTHON_USEDEP}]
			dev-python/mistune[${PYTHON_USEDEP}]
		)
	)
	mysql? ( dev-python/mysqlclient[${PYTHON_USEDEP}] )
	postgres? ( dev-python/psycopg:0[${PYTHON_USEDEP}] )
	pyjwt? ( dev-python/pyjwt[${PYTHON_USEDEP}] )
	sqlite? ( $(python_gen_impl_dep sqlite) )
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
	tz? ( dev-python/pytz[${PYTHON_USEDEP}] )
	whoosh? ( >=dev-python/whoosh-2.5.7[${PYTHON_USEDEP}] )
	xapian? ( >=dev-libs/xapian-bindings-1.0.0[python,${PYTHON_USEDEP}] )
"

DOCS="CHANGES.txt doc/*.txt"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# tries to connect to non-running server
	test/test_liveserver.py::TestPostgresWsgiServer
	test/test_sqlite.py::sqliteSessionTest
	test/test_sqlite.py::sqliteSpecialActionTestCase::testInnerMain
	# automagic, assumes a postgresql server is available
	test/test_config.py::TrackerConfig::testLoadSessionDbRedis

	# upstream issue:  https://issues.roundup-tracker.org/issue2551335
	test/test_templating.py::Markdown2TestCase::test_markdown_hyperlinked_url
	# upstream issue:  https://issues.roundup-tracker.org/issue2551336
	test/test_templating.py::Markdown2TestCase::test_string_markdown_link_item
)

python_install() {
	distutils-r1_python_install
	if [[ -d "${ED}"/usr/share ]]; then
		rm -r "${D}$(python_get_sitedir)"/usr
	else
		mv "${D}$(python_get_sitedir)"/usr/share "${ED}"/usr/ || die
		dodir /usr/share/doc/${PF}
		mv "${ED}"/usr/share/doc/${PN}/html "${ED}"/usr/share/doc/${PF}/ || die
		rmdir "${ED}"/usr/share/doc/${PN} || die
		rmdir "${D}$(python_get_sitedir)"/usr || die
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	find "${ED}"/usr/share/roundup -name __pycache__ -type d -exec rm -r {} +
}

pkg_postinst() {
	ewarn "See installation.txt for initialisation instructions."
	ewarn "See upgrading.txt for upgrading instructions."
}
