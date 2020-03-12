# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="a text-based calendar and scheduling application"
HOMEPAGE="https://calcurse.org/"
SRC_URI="https://calcurse.org/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="
	dev-python/httplib2
	sys-libs/ncurses:0="

DEPEND="
	${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.1-tinfo.patch
)

# Most tests fail.
RESTRICT="test"

src_prepare() {
	default
	eautoreconf
}
