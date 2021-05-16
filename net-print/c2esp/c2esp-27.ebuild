# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A CUPS filter for Kodak ESP printers"
HOMEPAGE="https://sourceforge.net/projects/cupsdriverkodak"
SRC_URI="mirror://sourceforge/cupsdriverkodak/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND=">=media-libs/jbigkit-2.0-r1:=
	>=net-print/cups-1.6
	sys-libs/zlib:="

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-missing-includes.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	# Don't trust cups-config in case ROOT!=/.

	econf \
		--with-cupsfilterdir="${EPREFIX}"/usr/libexec/cups/filter \
		--with-cupsdatadir="${EPREFIX}"/usr/share/cups
}
