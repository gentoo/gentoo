# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="Tiny 2D vector graphics library in C"
HOMEPAGE="https://github.com/sammycage/plutovg"
SRC_URI="https://github.com/sammycage/plutovg/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv"
