# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="Aiptek USB Digital Tablet Input Driver for Linux"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~sh sparc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-xorg-server-1.18.patch
)
