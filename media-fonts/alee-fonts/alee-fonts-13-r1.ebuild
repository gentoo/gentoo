# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Lee's Hangul truetype fonts"
HOMEPAGE="https://screenshots.debian.net/package/ttf-alee"
SRC_URI="http://turul.canonical.com/pool/main/t/ttf-alee/ttf-alee_${PV}.tar.gz"
S="${WORKDIR}/ttf-alee-${PV}"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

FONT_SUFFIX="ttf"
