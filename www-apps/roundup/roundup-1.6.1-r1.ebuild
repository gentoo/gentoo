# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Issue-tracking system with command-line, web, and e-mail interfaces"
HOMEPAGE="http://roundup.sourceforge.net https://pypi.org/project/roundup/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT ZPL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="+tz sqlite mysql postgres xapian whoosh ssl"

DEPEND=""
RDEPEND="${DEPEND}
	tz? ( dev-python/pytz[$PYTHON_USEDEP] )
	sqlite? ( dev-lang/python:*[sqlite] )
	mysql? ( dev-python/mysql-python[$PYTHON_USEDEP] )
	postgres? (
		>=dev-python/psycopg-1.1.21[$PYTHON_USEDEP]
		<dev-python/psycopg-2.8[$PYTHON_USEDEP]
	)
	xapian? ( >=dev-libs/xapian-bindings-1.0.0[python,$PYTHON_USEDEP] )
	whoosh? ( >=dev-python/whoosh-2.5.7[$PYTHON_USEDEP] )
	ssl? ( dev-python/pyopenssl[$PYTHON_USEDEP] )"

DOCS="CHANGES.txt doc/*.txt"

python_install_all() {
	distutils-r1_python_install_all
	rm -r "${ED}"/usr/share/doc/${PN} || die
}

pkg_postinst() {
	ewarn "See installation.txt for initialisation instructions."
	ewarn "See upgrading.txt for upgrading instructions."
}
