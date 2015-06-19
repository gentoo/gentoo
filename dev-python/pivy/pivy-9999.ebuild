# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pivy/pivy-9999.ebuild,v 1.2 2015/04/08 08:05:09 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit mercurial distutils-r1

DESCRIPTION="Coin3d binding for Python"
HOMEPAGE="http://pivy.coin3d.org/"
EHG_REPO_URI="http://hg.sim.no/Pivy/default"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	media-libs/coin
	>=media-libs/SoQt-1.5.0"
DEPEND="${RDEPEND}
	dev-lang/swig"
