# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=KWITKNR
DIST_VERSION=1.15
inherit perl-module

DESCRIPTION="Create barcode images with GD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"

RDEPEND="dev-perl/GD"
BDEPEND="${RDEPEND}"
