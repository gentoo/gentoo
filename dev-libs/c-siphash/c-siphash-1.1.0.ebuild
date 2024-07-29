# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Streaming-capable SipHash Implementation"
HOMEPAGE="
	https://c-util.github.io/c-siphash/
	https://github.com/c-util/c-siphash/
"
SRC_URI="
	https://github.com/c-util/c-siphash/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="|| ( Apache-2.0 LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

DEPEND="
	>=dev-libs/c-stdaux-1.5.0
"
BDEPEND="
	virtual/pkgconfig
"
