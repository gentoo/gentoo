# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/pymc/pymc-2.2.ebuild,v 1.3 2014/08/10 20:24:06 slyfox Exp $

EAPI=4

inherit distutils vcs-snapshot

DESCRIPTION="Markov Chain Monte Carlo sampling toolkit"
HOMEPAGE="http://github.com/${PN}-devs/${PN} http://pypi.python.org/pypi/${PN}"
SRC_URI="http://github.com/${PN}-devs/${PN}/tarball/v${PV} -> ${P}.tar.gz"

SLOT=0
KEYWORDS="~amd64-linux ~x86-linux"
LICENSE=AFL-3.0
IUSE=""

DEPEND="dev-python/setuptools
	dev-python/pytables
	dev-python/numpy"

src_compile() {
	distutils_src_compile --fcompiler=gnu95
}
