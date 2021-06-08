# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Relax-and-Recover is a setup-and-forget bare metal disaster recovery solution"
HOMEPAGE="http://relax-and-recover.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="udev samba"

RDEPEND="
	app-cdr/cdrtools
	net-dialup/mingetty
	net-fs/nfs-utils
	sys-apps/gawk
	sys-apps/iproute2
	sys-apps/lsb-release
	sys-apps/sed
	sys-apps/util-linux
	sys-block/parted
	sys-boot/syslinux
	dev-libs/openssl:0=
	samba? ( net-fs/cifs-utils )
	udev? ( virtual/udev )
"

src_compile() { :; }

src_install() {
	emake DESTDIR="${D}" install

	keepdir /var/lib/rear
	keepdir /var/log/rear
}
