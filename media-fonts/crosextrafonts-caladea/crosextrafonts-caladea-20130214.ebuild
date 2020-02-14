# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

MY_P=${P/-caladea/}
DESCRIPTION="Open licensed serif font metrically compatible with Cambria"
HOMEPAGE="https://bugs.chromium.org/p/chromium/issues/detail?id=168879"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks strip test"

S="${WORKDIR}/${MY_P}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
FONT_CONF=( "${FILESDIR}"/62-crosextra-caladea.conf )
