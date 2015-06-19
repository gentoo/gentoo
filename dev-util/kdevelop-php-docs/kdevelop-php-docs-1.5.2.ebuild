# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdevelop-php-docs/kdevelop-php-docs-1.5.2.ebuild,v 1.3 2014/01/26 11:38:58 ago Exp $

EAPI=5

KDE_LINGUAS="bs ca ca@valencia da de en_GB es et fi fr gl hu it nb nds nl pl pt
pt_BR ru sk sl sv tr uk zh_CN zh_TW"
KMNAME="kdevelop"
EGIT_REPONAME="kdev-php-docs"
inherit kde4-base

DESCRIPTION="PHP documentation plugin for KDevelop 4"
LICENSE="GPL-2 LGPL-2"
IUSE="debug"
SRC_URI="mirror://kde/stable/kdevelop/${KDEVELOP_VERSION}/src/${P}.tar.xz"

if [[ $PV == *9999* ]]; then
	KEYWORDS=""
else
	KEYWORDS="amd64 x86"
fi

RDEPEND="
	!=dev-util/kdevelop-plugins-1.0.0
"
