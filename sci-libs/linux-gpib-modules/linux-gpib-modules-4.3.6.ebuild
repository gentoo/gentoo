# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dkms

DESCRIPTION="Kernel modules for GPIB (IEEE 488.2) hardware"
HOMEPAGE="https://linux-gpib.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/linux-gpib/linux-gpib-${PV}.tar.gz"
S="${WORKDIR}/linux-gpib-kernel-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="debug"

COMMONDEPEND=""
RDEPEND="${COMMONDEPEND}
	acct-group/gpib
"
DEPEND="${COMMONDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# don't fix debian bugs if they break gentoo
	"${FILESDIR}/${PN}-4.3.4-depmod.patch"
)

MODULES_KERNEL_MIN=2.6.8

src_unpack() {
	default
	unpack "${WORKDIR}/linux-gpib-${PV}/linux-gpib-kernel-${PV}.tar.gz"
}

src_configure() {
	MODULES_MAKEARGS+=( LINUX_SRCDIR="${KV_OUT_DIR}" )
	use debug && MODULES_MAKEARGS+=( 'GPIB-DEBUG=1' )
}

src_compile() {
	local modlist=(
		agilent_82350b=gpib::drivers/gpib/agilent_82350b
		agilent_82357a=gpib::drivers/gpib/agilent_82357a
		cb7210=gpib::drivers/gpib/cb7210
		cec_gpib=gpib::drivers/gpib/cec
		fmh_gpib=gpib::drivers/gpib/fmh_gpib
		gpib_bitbang=gpib::drivers/gpib/gpio
		hp82335=gpib::drivers/gpib/hp_82335
		hp_82341=gpib::drivers/gpib/hp_82341
		ines_gpib=gpib::drivers/gpib/ines
		lpvo_usb_gpib=gpib::drivers/gpib/lpvo_usb_gpib
		nec7210=gpib::drivers/gpib/nec7210
		ni_usb_gpib=gpib::drivers/gpib/ni_usb
		gpib_common=gpib::drivers/gpib/sys
		tms9914=gpib::drivers/gpib/tms9914
		tnt4882=gpib::drivers/gpib/tnt4882
	)

	dkms_src_compile
}

src_install() {
	dkms_src_install

	dodoc ChangeLog AUTHORS README* NEWS
}
