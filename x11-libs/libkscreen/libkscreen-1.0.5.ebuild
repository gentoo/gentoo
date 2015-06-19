# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libkscreen/libkscreen-1.0.5.ebuild,v 1.6 2014/12/11 16:07:56 ago Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="KDE screen management library"
HOMEPAGE="https://projects.kde.org/projects/extragear/libs/libkscreen"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="debug"

RDEPEND="
	>=dev-libs/qjson-0.8
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXrandr
"
DEPEND="
	${RDEPEND}
	test? ( dev-qt/qttest:4 )
"
