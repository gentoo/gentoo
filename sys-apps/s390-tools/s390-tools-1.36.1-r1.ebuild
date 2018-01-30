# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs udev

DESCRIPTION="User space utilities for the zSeries (s390) Linux kernel and device drivers"
HOMEPAGE="http://www.ibm.com/developerworks/linux/linux390/s390-tools.html"
SRC_URI="http://download.boulder.ibm.com/ibmdl/pub/software/dw/linux390/ht_src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* s390"
IUSE="fuse ncurses pfm snmp zlib"

RDEPEND="fuse? ( sys-fs/fuse )
	ncurses? ( sys-libs/ncurses:0= )
	pfm? ( app-misc/pfm )
	snmp? ( net-analyzer/net-snmp )
	zlib? ( sys-libs/zlib )
	>=sys-apps/util-linux-2.30"
DEPEND="${RDEPEND}
	dev-util/indent
	app-admin/genromfs"

src_configure() {
	export MAKEOPTS+=" V=1"
	export HAVE_DRACUT=0
	export HAVE_FUSE=$(usex fuse 1 0)
	export HAVE_NCURSES=$(usex ncurses 1 0)
	export HAVE_SNMP=$(usex snmp 1 0)
	export HAVE_PFM=$(usex pfm 1 0)
	export HAVE_ZLIB=$(usex zlib 1 0)
	tc-export AR BUILD_CC CC CXX LD NM OBJCOPY
}

src_compile() {
	emake \
		AR="${AR}" \
		HOSTCC="${BUILD_CC}" \
		CC="${CC}" LINK="${CC}" \
		CXX="${CXX}" LINKXX="${CXX}" \
		LD="${LD}" \
		NM="${NM}" \
		OBJCOPY="${OBJCOPY}"
}

src_install() {
	default
	udev_dorules etc/udev/rules.d/*.rules

	# The chmem tool has moved to util-linux.
	rm "${ED}"/usr/sbin/{ch,ls}mem "${ED}"/usr/share/man/man8/{ch,ls}mem.8* || die
}
