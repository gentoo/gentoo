# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/nml/nml-0.4.0.ebuild,v 1.5 2015/05/19 22:12:57 mr_bones_ Exp $

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )
EHG_REPO_URI="http://hg.openttdcoop.org/nml"
EHG_REVISION="0.4.0"

inherit mercurial distutils-r1

DESCRIPTION="Compiler of NML files into grf/nfo files"
HOMEPAGE="http://dev.openttdcoop.org/projects/nml"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"

RDEPEND="dev-python/pillow[zlib,${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${P}.r5527-3b43d37dec19

DOCS=( docs/{changelog,readme}.txt )
PATCHES=( "${FILESDIR}"/${P}-build.patch )

src_install() {
	distutils-r1_src_install
	doman docs/nmlc.1
}
