# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1
MY_P=${P/_/}

DESCRIPTION="Issue-tracking system with command-line, web, and e-mail interfaces"
HOMEPAGE="http://roundup.sourceforge.net https://pypi.org/project/roundup/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT ZPL"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="+tz sqlite mysql postgres xapian whoosh ssl jinja pyjwt markdown"

DEPEND=""
RDEPEND="${DEPEND}
	tz? ( dev-python/pytz[$PYTHON_USEDEP] )
	sqlite? ( $(python_gen_impl_dep sqlite) )
	mysql? ( dev-python/mysqlclient[$PYTHON_USEDEP] )
	postgres? ( >=dev-python/psycopg-2.8[$PYTHON_USEDEP] )
	xapian? ( >=dev-libs/xapian-bindings-1.0.0[python,$PYTHON_USEDEP] )
	whoosh? ( >=dev-python/whoosh-2.5.7[$PYTHON_USEDEP] )
	ssl? ( dev-python/pyopenssl[$PYTHON_USEDEP] )
	jinja? ( dev-python/jinja[$PYTHON_USEDEP] )
	pyjwt? ( dev-python/pyjwt[$PYTHON_USEDEP] )
	markdown? (
		dev-python/markdown[$PYTHON_USEDEP]
		dev-python/markdown2[$PYTHON_USEDEP]
		dev-python/mistune[$PYTHON_USEDEP]
		)"

DOCS="CHANGES.txt doc/*.txt"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	rm -r "${ED}"/usr/share/doc/${PN} || die
}

pkg_postinst() {
	ewarn "See installation.txt for initialisation instructions."
	ewarn "See upgrading.txt for upgrading instructions."
}
