# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/-caladea/}
inherit font

DESCRIPTION="Open licensed serif font metrically compatible with Cambria"
HOMEPAGE="https://bugs.chromium.org/p/chromium/issues/detail?id=168879"
SRC_URI="https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks strip test"

FONT_CONF=( "${FILESDIR}"/62-crosextra-caladea.conf )
FONT_SUFFIX="ttf"
