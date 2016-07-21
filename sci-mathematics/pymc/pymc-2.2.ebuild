# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit distutils vcs-snapshot

DESCRIPTION="Markov Chain Monte Carlo sampling toolkit"
HOMEPAGE="https://github.com/${PN}-devs/${PN} https://pypi.python.org/pypi/${PN}"
SRC_URI="https://github.com/${PN}-devs/${PN}/tarball/v${PV} -> ${P}.tar.gz"

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
