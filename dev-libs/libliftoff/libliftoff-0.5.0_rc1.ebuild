# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

COMMIT="8d45eeae7f17459d4ca85680832df0a875b5f64b"

DESCRIPTION="Lightweight KMS plane library"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/libliftoff"
SRC_URI="https://gitlab.freedesktop.org/emersion/${PN}/-/archive/${COMMIT}/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
LICENSE="MIT"
SLOT="0"

RDEPEND="
	x11-libs/libdrm
"
DEPEND="
	${RDEPEND}
"
