# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libkvkontakte/libkvkontakte-4.12.0.ebuild,v 1.1 2015/06/29 16:21:14 johu Exp $

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
