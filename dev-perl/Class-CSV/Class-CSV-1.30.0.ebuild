# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DJR
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="Class based CSV parser/writer"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Class-Accessor
	dev-perl/Text-CSV_XS
"
