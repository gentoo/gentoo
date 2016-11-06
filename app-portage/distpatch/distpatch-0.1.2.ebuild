# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Distfile Patching Support for Gentoo Linux (tools)"
HOMEPAGE="https://www.gentoo.org/proj/en/infrastructure/distpatch/"
SRC_URI="https://github.com/rafaelmartins/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND=">=sys-apps/portage-2.1.8.3
	dev-python/snakeoil"
DEPEND="${CDEPEND}
	dev-python/setuptools"
RDEPEND="${CDEPEND}
	>=dev-util/diffball-1.0.1"
