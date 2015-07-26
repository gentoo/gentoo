# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdevelop-pg-qt/kdevelop-pg-qt-1.1.0.ebuild,v 1.2 2015/07/26 06:31:39 mgorny Exp $

EAPI=5

KDEBASE="kdevelop"
inherit kde4-base

if [[ $PV == *9999* ]]; then
	KEYWORDS=""
else
	SRC_URI="http://quickgit.kde.org/?p=${PN}.git&a=snapshot&h=${PV%%.0} -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A LL(1) parser generator used mainly by KDevelop language plugins"
LICENSE="LGPL-2"
IUSE="debug"

DEPEND="
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="dev-util/kdevelop:4"

S="${WORKDIR}/${PN}"
