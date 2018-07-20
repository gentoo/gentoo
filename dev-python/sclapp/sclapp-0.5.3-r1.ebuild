# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Framework for writing simple command-line applications"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://www.alittletooquiet.net/media/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pexpect[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-testsuite-fix-from-r235.patch"
)

python_test() {
	esetup.py test
}
