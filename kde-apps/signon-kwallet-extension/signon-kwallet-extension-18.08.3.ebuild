# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="KWallet extension for signond"
HOMEPAGE="https://01.org/gsso/"
KEYWORDS="amd64 x86"
LICENSE="GPL-2+"

DEPEND="
	$(add_frameworks_dep kwallet)
	net-libs/signond
"
RDEPEND="${DEPEND}"
