# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils linux-mod multilib toolchain-funcs udev

DESCRIPTION="Open-MX - Myrinet Express over Generic Ethernet Hardware"
HOMEPAGE="http://open-mx.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/34371/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug modules static-libs"

DEPEND="
		sys-apps/hwloc
		virtual/linux-sources
		virtual/pkgconfig"
RDEPEND="
		sys-apps/hwloc
		virtual/modutils"

MODULE_NAMES="open-mx(misc:${S}/driver/linux)"
BUILD_TARGETS="all"
BUILD_PARAMS="KDIR=${KERNEL_DIR}"

pkg_setup() {
	einfo "You can set desired mtu by setting OPEN_MX_MTU in make.conf"
	linux-mod_pkg_setup
}

src_prepare() {
	# We still want to configure driver but dont want to build it at all
	epatch "${FILESDIR}/open-mx-1.4.0-driver.patch"
	# We dont want tests
	sed -e 's:tests/mx::g' \
		-e 's:tests::g' \
		-i Makefile.am || die "sed failed"
	eautoreconf
}

src_configure() {
	econf \
		--with-mtu=${OPEN_MX_MTU:-9000} \
		--with-linux="${KERNEL_DIR}" \
		--with-linux-release=${KV_FULL} \
		$(use_enable static-libs static) \
		$(use_enable debug)
}

src_compile() {
	default
	if use modules; then
		cd "${S}/driver/linux"
		linux-mod_src_compile || die "failed to build driver"
	fi
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.*a' -exec rm {} +
	# Drop init scripts
	rm -rf "${ED}/usr/sbin" || die
	rm "${ED}/usr/bin/omx_check"
	# install udev rules
	udev_dorules "${ED}/etc/open-mx/10-open-mx.rules"
	dodoc "${ED}/usr/share/open-mx/FAQ.html"
	# Drop misc stuff
	rm "${ED}/etc/open-mx/10-open-mx.rules" || die
	rm -rf "${ED}/usr/share/open-mx" || die
	newinitd "${FILESDIR}/omxoed.initd" omxoed
	if use modules; then
		cd "${S}/driver/linux"
		linux-mod_src_install || die "failed to install driver"
	fi
}
