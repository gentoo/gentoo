# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Lightweight KMS plane library"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/libliftoff"
SRC_URI="https://gitlab.freedesktop.org/emersion/${PN}/-/releases/v${PV}/downloads/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="
	x11-libs/libdrm
"
DEPEND="
	${RDEPEND}
"
