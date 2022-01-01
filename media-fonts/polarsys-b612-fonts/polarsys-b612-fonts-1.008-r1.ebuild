# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Font designed for aircraft cockpit displays"
HOMEPAGE="https://b612-font.com/"
SRC_URI="https://github.com/polarsys/b612/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0 BSD OFL-1.1"   # to be clarified #746725
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ppc ppc64 ~x86"

S="${WORKDIR}/b612-${PV}"
FONT_S="${S}/fonts/ttf"
FONT_SUFFIX="ttf"

DOCS=( README.md )
