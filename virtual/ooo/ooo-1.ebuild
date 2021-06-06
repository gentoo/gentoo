# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for LibreOffice"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	|| (
		app-office/libreoffice
		app-office/libreoffice-bin
	)
"
