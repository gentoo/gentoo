# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a tool to probe system hardware, check operability and upload results"
HOMEPAGE="https://github.com/linuxhw/hw-probe"
SRC_URI="https://github.com/linuxhw/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-linux ~amd64-linux ~arm ~ppc"

DEPEND="
	dev-lang/perl
	virtual/perl-Getopt-Long"
RDEPEND="${DEPEND}
	dev-perl/libwww-perl
	dev-perl/HTML-Parser
	virtual/perl-Digest-SHA
	net-misc/curl
	sys-apps/hwinfo
	sys-apps/pciutils
	sys-apps/usbutils
	sys-apps/smartmontools
	sys-apps/hdparm
	sys-apps/dmidecode
	sys-apps/util-linux
	sys-apps/lm_sensors
	sys-power/pmtools
	sys-power/iasl"

src_install() {
	emake install prefix="${D}usr"
	default
}
