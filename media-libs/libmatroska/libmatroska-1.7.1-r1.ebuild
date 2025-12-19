# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Extensible multimedia container format based on EBML"
HOMEPAGE="https://www.matroska.org/ https://github.com/Matroska-Org/libmatroska/"
SRC_URI="https://dl.matroska.org/downloads/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/7" # subslot = soname major version
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"

RDEPEND=">=dev-libs/libebml-1.4.3:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.1-cmake-4.patch
)
