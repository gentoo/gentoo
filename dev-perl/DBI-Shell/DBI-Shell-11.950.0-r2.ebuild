# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TLOWERY
DIST_VERSION=11.95
inherit perl-module

DESCRIPTION="Interactive command shell for the DBI"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-perl/IO-Tee
	dev-perl/Text-Reform
	dev-perl/DBI
	dev-perl/Text-CSV_XS"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-perl526.patch"
	"${FILESDIR}/${P}-local-scalar.patch"
	"${FILESDIR}/${P}-nochrdir.patch"
	"${FILESDIR}/${P}-sprintf-warn.patch"
)
