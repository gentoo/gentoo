# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A probe for hardware, check operability and upload result to the Linux HW DB"
HOMEPAGE="https://github.com/linuxhw/hw-probe/"
SRC_URI="https://github.com/linuxhw/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~ppc ~x86"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="i2c inxi memtester mesa pnp rfkill scanner smartcard sysstat vaapi vulkan xinput"

RDEPEND="
	dev-lang/perl
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	net-misc/curl
	sys-apps/dmidecode
	sys-apps/hdparm
	sys-apps/hwinfo
	sys-apps/lm-sensors
	sys-apps/pciutils
	sys-apps/smartmontools
	sys-apps/usbutils
	sys-apps/util-linux
	virtual/perl-Data-Dumper
	virtual/perl-Digest-SHA
	virtual/perl-Getopt-Long
	amd64? (
		app-admin/mcelog
		sys-apps/edid-decode
		sys-power/iasl
		sys-power/pmtools
		vulkan? (
			dev-util/vulkan-tools
		)
	)
	i2c? ( sys-apps/i2c-tools )
	inxi? ( sys-apps/inxi )
	memtester? ( sys-apps/memtester )
	mesa? ( x11-apps/mesa-progs )
	pnp? ( !arm? ( !ppc? ( sys-apps/pnputils ) ) )
	ppc? (
		sys-power/iasl
		sys-power/pmtools
	)
	rfkill? ( net-wireless/rfkill )
	scanner? ( media-gfx/sane-backends )
	smartcard? ( dev-libs/opensc )
	sysstat? ( app-admin/sysstat )
	vaapi? ( x11-libs/libva )
	x86? (
		app-admin/mcelog
		sys-apps/edid-decode
		sys-power/iasl
		sys-power/pmtools
	)
	xinput? ( x11-apps/xinput )
"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

src_compile() {
	:;
}
