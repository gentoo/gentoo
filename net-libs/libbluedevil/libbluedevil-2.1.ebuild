# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Qt wrapper for bluez used in the KDE bluetooth stack"
HOMEPAGE="https://projects.kde.org/projects/playground/libs/libbluedevil"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
IUSE="debug"

RDEPEND=">=net-wireless/bluez-5"
