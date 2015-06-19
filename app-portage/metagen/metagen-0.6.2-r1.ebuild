# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/metagen/metagen-0.6.2-r1.ebuild,v 1.10 2015/04/25 16:25:44 floppym Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="metadata.xml generator for ebuilds"
HOMEPAGE="http://cgit.gentoo.org/proj/metagen.git"
SRC_URI="http://dev.gentoo.org/~neurogeek/metagen_releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~amd64-linux ~x86-linux"

IUSE=""
DEPEND=">=dev-python/jaxml-3.01[${PYTHON_USEDEP}]
	>=sys-apps/portage-2.1.9.42[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_install() {
	distutils-r1_python_install
	python_newscript metagen/main.py metagen
}

python_install_all() {
	distutils-r1_python_install_all
	doman docs/metagen.1
}

python_test() {
	"${PYTHON}" -c "from metagen import metagenerator; metagenerator.do_tests()" || die
}
