# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Yeraze's TNEF Stream Reader - for winmail.dat files"
HOMEPAGE="https://github.com/Yeraze/ytnef"
SRC_URI="https://github.com/Yeraze/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="sys-devel/libtool"

src_prepare() {
	default
	eautoreconf
}
