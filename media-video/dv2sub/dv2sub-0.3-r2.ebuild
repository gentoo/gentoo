# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Extract info or subtitles from DV stream"
HOMEPAGE="http://dv2sub.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/dv2sub/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="media-libs/libdv"
RDEPEND="${DEPEND}"
