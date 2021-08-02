# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="Userspace helper for Linux kernel EDAC drivers"
HOMEPAGE="https://github.com/grondo/edac-utils"
SRC_URI="https://github.com/grondo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="debug"

DEPEND="sys-fs/sysfsutils"
RDEPEND="${DEPEND}
	sys-apps/dmidecode"

src_prepare() {
	default

	# Needed to refresh libtool and friends to not call CC directly
	# bug #725540
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable debug)
}

src_install() {
	default

	# Dump the inappropriate-for-us bundled init script
	rm -rf "${ED}/etc/init.d" || die

	# Install our own
	newinitd "${FILESDIR}"/edac.init edac
	systemd_dounit "${FILESDIR}"/edac.service

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "There must be an entry for your mainboard in ${EROOT}/etc/edac/labels.db"
	elog "in case you want nice labels in /sys/module/*_edac/"
	elog "Run the following command to check whether such an entry is already available:"
	elog "    edac-ctl --print-labels"
}
