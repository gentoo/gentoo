# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs udev

DESCRIPTION="User space utilities for the zSeries (s390) Linux kernel and device drivers"
HOMEPAGE="https://github.com/ibm-s390-tools/s390-tools"
SRC_URI="https://github.com/ibm-${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~s390"
IUSE="abi_s390_32 cryptsetup curl fuse ncurses openssl pfm snmp zlib"

RDEPEND="
	curl? ( net-misc/curl )
	fuse? ( sys-fs/fuse:3= )
	ncurses? ( sys-libs/ncurses:= )
	openssl? (
		dev-libs/openssl:=
		cryptsetup? (
			>=sys-fs/cryptsetup-2.0.3:=
			dev-libs/json-c:=
		)
	)
	pfm? ( dev-libs/libpfm:= )
	snmp? ( net-analyzer/net-snmp:= )
	zlib? ( virtual/zlib:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-admin/genromfs
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -i -e 's/-lncurses/-lncurses -ltinfo/' "${S}"/hyptop/Makefile || die

	# zipl only builds on 64bit
	if use abi_s390_32 ; then
		sed -i -e 's/^TOOL_DIRS = zipl /TOOL_DIRS = /' "${S}"/Makefile || die
	fi
}

src_configure() {
	# https://github.com/ibm-s390-linux/s390-tools/tree/master?tab=readme-ov-file#dependencies
	export MAKEOPTS+=" V=1"
	export HAVE_DRACUT=0
	export HAVE_CARGO=0
	export HAVE_FUSE=$(usex fuse 1 0)
	export HAVE_NCURSES=$(usex ncurses 1 0)
	export HAVE_SNMP=$(usex snmp 1 0)
	export HAVE_PFM=$(usex pfm 1 0)
	export HAVE_ZLIB=$(usex zlib 1 0)
	export HAVE_OPENSSL=$(usex openssl 1 0)
	export HAVE_CRYPTSETUP2=$(usex cryptsetup 1 0)
	export HAVE_JSONC=$(usex cryptsetup 1 0)
	# Yes, really. Half the code uses one, the other half the other.
	export HAVE_CURL=$(usex curl 1 0)
	export HAVE_LIBCURL=$(usex curl 1 0)
	# These need checking, but disabled for now to avoid automagic
	export HAVE_GLIB2=0
	export HAVE_LIBXML2=0
	export HAVE_SYSTEMD=0
	export HAVE_LIBUDEV=0
	export HAVE_LIBNL3=0
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
	keepdir /var/log/ts-shell
}
