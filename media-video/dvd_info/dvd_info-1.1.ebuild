# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="DVD utilities to print information, copy tracks, etc."
HOMEPAGE="https://github.com/beandog/dvd_info"
SRC_URI="https://downloads.sourceforge.net/dvdinfo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libdvdread"
RDEPEND="${DEPEND}"
