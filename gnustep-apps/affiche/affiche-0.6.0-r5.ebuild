# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

DESCRIPTION="Affiche allows people to 'stick' notes"
HOMEPAGE="https://salsa.debian.org/gnustep-team/affiche.app"
SRC_URI="mirror://gentoo/${P/a/A}.tar.gz"
S="${WORKDIR}/${PN/a/A}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
