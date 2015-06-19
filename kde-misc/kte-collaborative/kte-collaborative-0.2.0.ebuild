# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kte-collaborative/kte-collaborative-0.2.0.ebuild,v 1.1 2013/10/29 22:02:10 johu Exp $

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
	net-im/ktp-common-internals
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
