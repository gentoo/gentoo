# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="HP48 Calculator Emulator"
HOMEPAGE="https://sourceforge.net/projects/x48.berlios/"
SRC_URI="https://downloads.sourceforge.net/x48.berlios/${P}.tar.bz2"
S=${WORKDIR}

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ppc64 ~sparc ~x86"
IUSE="readline"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-libs/libXt"

PATCHES=(
	"${FILESDIR}"/${P}-static.patch
	"${FILESDIR}"/${P}-void_return.patch
	"${FILESDIR}"/${P}-configure.patch
	)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable readline)
}

src_install() {
	default

	insinto /usr/share/"${PN}"/romdump
	doins -r romdump/{README,ROMDump*}
}

pkg_postinst() {
	elog "The X48 emulator requires an HP48 ROM image to run."
	elog
	elog "If you own an HP-48 calculator, you can use the ROMDump utility"
	elog "included with this package to obtain it from your calculator."
	elog "The instructions of how to do this are included in the package."
	elog
	elog "Alternatively, HP has provided the ROM images for non-commercial"
	elog "use only."
	elog
	elog "Due to confusion over the legal status of these ROMs you must"
	elog "manually download one from http://www.hpcalc.org/hp48/pc/emulators/"
	elog
	elog "If you do not know which one to use, try 'HP 48GX Revision R ROM.'"
	elog
	elog "Once you have a ROM, you will need to install it by running:"
	elog
	elog "x48 -rom gxrom-r"
	elog
	elog "You will only have to do this the first time you run X48. The"
	elog "ROM will be stored in ~/.hp48/rom for future runs."
}
