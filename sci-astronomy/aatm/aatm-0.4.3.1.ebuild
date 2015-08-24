# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="Atmospheric Modelling for ALMA Observatory"
HOMEPAGE="http://www.mrao.cam.ac.uk/~bn204/alma/atmomodel.html"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz
	https://dev.gentoo.org/~bicatali/distfiles/${P}-ac-boost.patch.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}"

PATCHES=( "${WORKDIR}"/${P}-ac-boost.patch )
