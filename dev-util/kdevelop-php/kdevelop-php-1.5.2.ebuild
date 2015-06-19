# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdevelop-php/kdevelop-php-1.5.2.ebuild,v 1.3 2014/01/26 11:38:54 ago Exp $

EAPI=5

KDE_LINGUAS="bs ca ca@valencia da de el en_GB es et fi fr gl hu it kk nb nds nl
pl pt pt_BR ru sl sv th uk zh_CN zh_TW"
VIRTUALX_REQUIRED=test
KDEBASE="kdevelop"
KMNAME="kdev-php"
EGIT_REPONAME="${KMNAME}"
inherit kde4-base

DESCRIPTION="PHP plugin for KDevelop 4"
LICENSE="GPL-2 LGPL-2"
IUSE="debug doc"
SRC_URI="mirror://kde/stable/kdevelop/${KDEVELOP_VERSION}/src/${P}.tar.xz"

if [[ $PV != *9999* ]]; then
	KEYWORDS="amd64 x86"
else
	KEYWORDS=""
fi

DEPEND="
	>=dev-util/kdevelop-pg-qt-1.0.0
"
RDEPEND="
	dev-util/kdevelop
	doc? ( >=dev-util/kdevelop-php-docs-${PV}:${SLOT} )
"
PATCHES=( "${FILESDIR}/${PN}"-1.2.0-parmake.patch )

RESTRICT="test"
