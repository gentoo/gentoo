# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pymountboot/pymountboot-0.2.1.ebuild,v 1.6 2015/04/08 08:05:23 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="Python extension module to (re)mount /boot"
HOMEPAGE="https://bitbucket.org/mgorny/pymountboot/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-apps/util-linux-2.20"
DEPEND="${RDEPEND}"
