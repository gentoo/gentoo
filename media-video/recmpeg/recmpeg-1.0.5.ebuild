# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple libfame-based video encoder, compresses raw video sequences to MPEG video"
HOMEPAGE="http://fame.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/fame/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"

RDEPEND=">=media-libs/libfame-0.9.0"
DEPEND="${RDEPEND}"
