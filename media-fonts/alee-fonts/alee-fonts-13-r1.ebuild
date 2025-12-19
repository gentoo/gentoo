# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Lee's Hangul truetype fonts"
HOMEPAGE="https://screenshots.debian.net/package/ttf-alee"
SRC_URI="http://turul.canonical.com/pool/main/t/ttf-alee/ttf-alee_${PV}.tar.gz"
S="${WORKDIR}/ttf-alee-${PV}"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE=""

FONT_SUFFIX="ttf"
