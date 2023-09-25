# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_SUFFIX="otf"

inherit font

DESCRIPTION="Intel One Mono font family"
HOMEPAGE="https://github.com/intel/intel-one-mono"

SRC_URI="https://github.com/intel/intel-one-mono/releases/download/V${PV}/otf.zip -> ${P}.zip"
S="${WORKDIR}/otf"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="binchecks strip"

BDEPEND="
	app-arch/unzip
"

src_compile() { :; }
