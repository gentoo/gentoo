# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Userspace helper for Linux kernel EDAC drivers"
HOMEPAGE="https://github.com/grondo/edac-utils"
SRC_URI="https://github.com/grondo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="debug"

DEPEND="sys-fs/sysfsutils"
RDEPEND="${DEPEND}
	sys-apps/dmidecode"

src_configure() {
	econf \
		--disable-static \
		$(use_enable debug)
}

src_install() {
	default

	# We don't need this init.d file
	# Modules should be loaded by adding them to /etc/conf.d/modules
	# The rest is done via the udev-rule
	rm -rf "${D}/etc/init.d"

	prune_libtool_files
}

pkg_postinst() {
	elog "There must be an entry for your mainboard in /etc/edac/labels.db"
	elog "in case you want nice labels in /sys/module/*_edac/"
	elog "Run the following command to check whether such an entry is already available:"
	elog "    edac-ctl --print-labels"
}
