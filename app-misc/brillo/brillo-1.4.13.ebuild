# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Brillo controls the brightness of backlight and LED devices on Linux"
HOMEPAGE="https://gitlab.com/cameronnemo/brillo"
SRC_URI="https://gitlab.com/cameronnemo/brillo/-/archive/v${PV}/brillo-v${PV}.tar.bz2 -> brillo-${PV}.tar.bz2"

S="${WORKDIR}/brillo-v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${DEPEND}"
BDEPEND="dev-go/go-md2man"
