# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Typeface designed for source code"
HOMEPAGE="https://github.com/source-foundry/Hack"
SRC_URI="https://github.com/source-foundry/Hack/releases/download/v${PV}/Hack-v${PV}-ttf.tar.xz"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 x86"
IUSE=""

RESTRICT="binchecks strip"

FONT_SUFFIX="ttf"
