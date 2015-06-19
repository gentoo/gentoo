# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/minfx/minfx-1.0.4_pre98.ebuild,v 1.5 2015/04/08 18:49:15 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} pypy )

inherit distutils-r1

DESCRIPTION="Numerical optimisation library"
HOMEPAGE="http://gna.org/projects/minfx"
#SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
