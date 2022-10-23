# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Translate TEX into HTML"
HOMEPAGE="http://hutchinson.belmont.ma.us/tth/"
# mirror://sourceforge/${PN}/${PN}${PV}.tar.gz
SRC_URI="http://hutchinson.belmont.ma.us/tth/tth-noncom/${PN}_${PV}.tgz"
S="${WORKDIR}"/${PN}_C

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	app-text/ghostscript-gpl
	media-libs/netpbm
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.16-Fix-build-with-Clang-16.patch
)

src_compile() {
	# Upstream support a wide variety of obsolete platforms and
	# are still active, so no point in patching these, bug #874744.
	# http://hutchinson.belmont.ma.us/tth/platform.html
	append-flags -std=gnu89 -Wno-strict-prototypes

	emake tth tthsplit
}

src_install() {
	dobin tth latex2gif ps2gif ps2png tthsplit
	dodoc CHANGES
	doman tth.1
}
