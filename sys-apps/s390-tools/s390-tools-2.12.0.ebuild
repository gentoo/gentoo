# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs udev

DESCRIPTION="User space utilities for the zSeries (s390) Linux kernel and device drivers"
HOMEPAGE="https://github.com/ibm-s390-tools/s390-tools"
SRC_URI="https://github.com/ibm-${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* s390"
IUSE="cryptsetup fuse ncurses openssl pfm snmp zlib"

RDEPEND="fuse? ( sys-fs/fuse:0= )
	ncurses? ( sys-libs/ncurses:0= )
	openssl? (
		dev-libs/openssl:0=
		cryptsetup? (
			>=sys-fs/cryptsetup-2.0.3:=
			dev-libs/json-c:=
		)
	)
	pfm? ( app-misc/pfm )
	snmp? ( net-analyzer/net-snmp )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	dev-util/indent
	app-admin/genromfs"

src_prepare() {
	default
	sed -i -e 's/-lncurses/-lncurses -ltinfo/' "${S}"/hyptop/Makefile || die
}

src_configure() {
	export MAKEOPTS+=" V=1"
	export HAVE_DRACUT=0
	export HAVE_FUSE=$(usex fuse 1 0)
	export HAVE_NCURSES=$(usex ncurses 1 0)
	export HAVE_SNMP=$(usex snmp 1 0)
	export HAVE_PFM=$(usex pfm 1 0)
	export HAVE_ZLIB=$(usex zlib 1 0)
	export HAVE_OPENSSL=$(usex openssl 1 0)
	export HAVE_CRYPTSETUP2=$(usex cryptsetup 1 0)
	export HAVE_JSONC=$(usex cryptsetup 1 0)
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
}
