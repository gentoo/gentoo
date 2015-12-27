# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="Official GTK+ port of KDE's Breeze widget style"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/breeze-gtk"
SRC_URI="mirror://kde/stable/plasma/5.5.0/${P}.tar.xz"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${PN}-5.5.2-cmake-version.patch" )

S=${WORKDIR}/${PN}-5.5.0
