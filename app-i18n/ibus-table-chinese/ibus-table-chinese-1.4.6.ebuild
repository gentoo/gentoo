# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="Chinese input tables for ibus-table"
HOMEPAGE="https://github.com/definite/ibus-table-chinese"
MY_P="${P}-Source"
SRC_URI="https://ibus.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/ibus-table-1.2.0"
DEPEND="${RDEPEND}
	dev-util/cmake-fedora"

CMAKE_IN_SOURCE_BUILD=1
S="${WORKDIR}/${MY_P}"
