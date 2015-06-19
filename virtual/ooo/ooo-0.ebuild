# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/ooo/ooo-0.ebuild,v 1.9 2015/02/15 21:19:06 dilfridge Exp $

EAPI=4

DESCRIPTION="Virtual for OpenOffice.org/LibreOffice"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="java"

DEPEND=""
RDEPEND="
	|| (
		app-office/libreoffice[java?]
		app-office/libreoffice-bin[java?]
		app-office/openoffice-bin[java?]
	)
"
