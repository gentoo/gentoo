# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdevelop-php-docs/kdevelop-php-docs-1.7.1.ebuild,v 1.2 2015/08/06 11:47:34 ago Exp $

EAPI=5

KDE_LINGUAS="bs ca ca@valencia da de el en_GB es et fi fr gl hu it kk nb nds nl
pl pt pt_BR ru sk sl sv tr uk zh_CN zh_TW"
KMNAME="kdevelop"
EGIT_REPONAME="kdev-php-docs"
EGIT_BRANCH="1.7"
inherit kde4-base

DESCRIPTION="PHP documentation plugin for KDevelop 4"
LICENSE="GPL-2 LGPL-2"
IUSE="debug"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="amd64 ~x86"
fi

RDEPEND="
	!=dev-util/kdevelop-plugins-1.0.0
"
