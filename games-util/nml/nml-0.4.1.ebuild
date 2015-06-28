# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/nml/nml-0.4.1.ebuild,v 1.4 2015/06/28 10:09:13 zlogene Exp $

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )
inherit distutils-r1

DESCRIPTION="Compiler of NML files into grf/nfo files"
HOMEPAGE="http://dev.openttdcoop.org/projects/nml"
SRC_URI="http://bundles.openttdcoop.org/nml/releases/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"

RDEPEND="dev-python/pillow[zlib,${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( docs/{changelog,readme}.txt )

src_install() {
	distutils-r1_src_install
	doman docs/nmlc.1
}
