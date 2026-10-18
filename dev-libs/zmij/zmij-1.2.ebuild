# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A fast floating-point-to-string conversion library for C and C++"
HOMEPAGE="https://github.com/vitaut/zmij"
SRC_URI="https://github.com/vitaut/zmij/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}/zmij-1.2-soname.patch"
)
