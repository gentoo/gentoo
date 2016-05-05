# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DECLARATIVE_REQUIRED="always"
VIRTUALX_REQUIRED="test"
MY_P="${PN}-v${PV}"
KDE_LINGUAS="bs cs de fr hu nl pl pt pt_BR sk sv ug uk"
inherit kde4-base

DESCRIPTION="Collaborative text editor via kde-telepathy"
HOMEPAGE="https://projects.kde.org/projects/playground/network/kte-collaborative"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	dev-libs/glib:2
	kde-apps/ktp-common-internals:4
	net-libs/libinfinity[server]
	net-libs/libqinfinity
	>=net-libs/telepathy-qt-0.8.9
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
"

# hangs
RESTRICT="test"

S=${WORKDIR}/${MY_P}
