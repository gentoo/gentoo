# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for LibreOffice"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	|| (
		app-office/libreoffice
		app-office/libreoffice-bin
	)
"
