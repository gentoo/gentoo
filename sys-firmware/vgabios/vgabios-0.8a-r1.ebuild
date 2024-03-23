# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="VGA BIOS implementation"
HOMEPAGE="https://www.nongnu.org/vgabios/"
SRC_URI="https://savannah.gnu.org/download/${PN}/${P}.tgz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="binary debug"
BDEPEND="!binary? ( sys-devel/dev86 )"

src_compile() {
	if ! use binary ; then
		emake clean # Necessary to clean up the pre-built pieces
		emake biossums CC="$(tc-getCC)"
		emake GCC="$(tc-getCC)" CC="$(tc-getCC)"
	fi
}

src_install() {
	insinto /usr/share/vgabios

	# Stock VGABIOS
	newins VGABIOS-lgpl-latest.bin vgabios.bin
	use debug && newins VGABIOS-lgpl-latest.debug.bin vgabios.debug.bin

	# Cirrus
	newins VGABIOS-lgpl-latest.cirrus.bin vgabios-cirrus.bin
	use debug && newins VGABIOS-lgpl-latest.cirrus.debug.bin \
		vgabios-cirrus.debug.bin

	# Banshee
	newins VGABIOS-lgpl-latest.banshee.bin vgabios-banshee.bin

}
