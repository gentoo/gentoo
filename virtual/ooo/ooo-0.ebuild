# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for OpenOffice.org/LibreOffice"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="java"

RDEPEND="
	|| (
		app-office/libreoffice[java?]
		app-office/libreoffice-bin[java?]
		app-office/openoffice-bin[java?]
	)
"
