# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Unicode font for the standardized Yi script"
HOMEPAGE="https://software.sil.org/nuosu/"
SRC_URI="https://software.sil.org/downloads/r/nuosu/NuosuSIL-${PV}.zip"
S="${WORKDIR}/NuosuSIL-${PV}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"
