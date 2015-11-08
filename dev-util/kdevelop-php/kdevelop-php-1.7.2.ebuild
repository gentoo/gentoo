# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="bs ca ca@valencia da de el en_GB es et fi fr gl it kk nl pl pt
pt_BR ru sk sl sv tr uk zh_CN zh_TW"
VIRTUALX_REQUIRED=test
KDEBASE="kdevelop"
KMNAME="kdev-php"
EGIT_REPONAME="${KMNAME}"
EGIT_BRANCH="1.7"
inherit kde4-base

DESCRIPTION="PHP plugin for KDevelop 4"
LICENSE="GPL-2 LGPL-2"
IUSE="debug doc"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

RESTRICT="test"

DEPEND="
	>=dev-util/kdevelop-pg-qt-1.0.0:4
"
RDEPEND="
	dev-util/kdevelop:${SLOT}
	doc? ( >=dev-util/kdevelop-php-docs-${PV}:${SLOT} )
"

PATCHES=( "${FILESDIR}/${PN}"-1.2.0-parmake.patch )
