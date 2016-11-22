# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=true

inherit autotools-utils systemd linux-info

DESCRIPTION="Distribute hardware interrupts across processors on a multiprocessor system"
HOMEPAGE="https://github.com/Irqbalance/irqbalance"
SRC_URI="https://github.com/Irqbalance/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="caps +numa selinux"

CDEPEND="
	dev-libs/glib:2
	caps? ( sys-libs/libcap-ng )
	numa? ( sys-process/numactl )
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-irqbalance )
"

pkg_setup() {
	CONFIG_CHECK="~PCI_MSI"
	linux-info_pkg_setup
}

src_prepare() {
	# Follow systemd policies
	# https://wiki.gentoo.org/wiki/Project:Systemd/Ebuild_policy
	sed -i -e 's/ $IRQBALANCE_ARGS//' misc/irqbalance.service || die
	sed -i -e '/EnvironmentFile/d' misc/irqbalance.service || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_with caps libcap-ng)
		$(use_enable numa)
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	newinitd "${FILESDIR}"/irqbalance.init.3 irqbalance
	newconfd "${FILESDIR}"/irqbalance.confd-1 irqbalance
	systemd_dounit misc/irqbalance.service
}
