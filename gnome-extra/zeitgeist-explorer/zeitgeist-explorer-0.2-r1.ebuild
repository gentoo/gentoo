# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/zeitgeist-explorer/zeitgeist-explorer-0.2-r1.ebuild,v 1.4 2015/04/08 17:56:31 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 versionator

MY_PV="$(get_version_component_range 1-2)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Monitor and inspect Zeitgeist's log at a low level - developer tool"
HOMEPAGE="https://launchpad.net/zeitgeist-explorer/"
SRC_URI="https://launchpad.net/${PN}/0.x/${MY_PV}/+download/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	gnome-extra/zeitgeist
	x11-libs/gtk+:3[introspection]"
DEPEND="${RDEPEND}
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]"

DISTUTILS_NO_PARALLEL_BUILD=true
