# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for SKK server"

SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="|| (
		app-i18n/skkserv
		app-i18n/dbskkd-cdb
		app-i18n/mecab-skkserv
		app-i18n/multiskkserv
		app-i18n/yaskkserv
	)"
