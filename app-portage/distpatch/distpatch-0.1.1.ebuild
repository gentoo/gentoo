# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND='*:2.6'
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS='2.4 2.5 3.*'

inherit distutils

DESCRIPTION="Distfile Patching Support for Gentoo Linux (tools)"
HOMEPAGE="http://www.gentoo.org/proj/en/infrastructure/distpatch/"
SRC_URI="mirror://github/rafaelmartins/${PN}/${P}.tar.gz"

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
