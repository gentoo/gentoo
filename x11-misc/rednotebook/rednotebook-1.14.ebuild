# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Graphical journal with calendar, templates, tags and keyword searching"
HOMEPAGE="http://rednotebook.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="libyaml"

RDEPEND="
	>=dev-python/pyyaml-3.05[libyaml?,${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.16[${PYTHON_USEDEP}]
	>=dev-python/pywebkitgtk-1.1.5[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
