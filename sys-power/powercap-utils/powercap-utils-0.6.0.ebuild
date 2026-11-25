# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C bindings to the Linux Power Capping Framework in sysfs"
HOMEPAGE="https://github.com/powercap/powercap"
SRC_URI="https://github.com/powercap/powercap/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

S="${WORKDIR}/powercap-${PV}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="virtual/pkgconfig"
