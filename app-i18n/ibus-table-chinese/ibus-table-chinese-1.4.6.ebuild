# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-table-chinese/ibus-table-chinese-1.4.6.ebuild,v 1.1 2013/02/05 11:46:33 yngwin Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="Chinese input tables for ibus-table"
HOMEPAGE="https://github.com/definite/ibus-table-chinese"
MY_P="${P}-Source"
SRC_URI="http://ibus.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/ibus-table-1.2.0"
DEPEND="${RDEPEND}
	dev-util/cmake-fedora"

CMAKE_IN_SOURCE_BUILD=1
S="${WORKDIR}/${MY_P}"
