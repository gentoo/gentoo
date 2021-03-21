# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Hellenisation of the wonderful, monospace, open/free font Inconsolata"
HOMEPAGE="https://www.cosmix.org/software/"
SRC_URI="https://www.cosmix.org/software/files/InconsolataHellenic.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"
