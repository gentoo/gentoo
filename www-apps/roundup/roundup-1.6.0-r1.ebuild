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

DEPEND=""
RDEPEND="${DEPEND}"

DOCS="CHANGES.txt doc/*.txt"

PATCHES=(
	"${FILESDIR}/${P}-configparser.patch"
	"${FILESDIR}/${P}-csrf-headers.patch"
	"${FILESDIR}/${P}-xss.patch"
)

python_install_all() {
	distutils-r1_python_install_all
	rm -r "${ED}"/usr/share/doc/${PN} || die
}

pkg_postinst() {
	ewarn "See installation.txt for initialisation instructions."
	ewarn "See upgrading.txt for upgrading instructions."
}
