# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="SIMD Vector Class Library for C++"
HOMEPAGE="https://github.com/VcDevel/Vc"
SRC_URI="https://github.com/VcDevel/Vc/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/Vc-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
