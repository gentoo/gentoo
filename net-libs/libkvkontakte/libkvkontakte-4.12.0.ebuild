# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="ar bs cs da de el en_GB es et fi fr gl hu it kk km ko nb nds nl pl
pt pt_BR ro ru sk sl sv tr uk zh_TW"
inherit kde4-base

DESCRIPTION="Library for accessing the features of social networking site vkontakte.ru"
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-libs/qjson-0.7.0"
RDEPEND="${DEPEND}"

# accessing network
RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )
