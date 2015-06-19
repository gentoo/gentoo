# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ixp4xx/ixp4xx-2.1.ebuild,v 1.5 2010/10/28 12:32:57 ssuominen Exp $

inherit eutils toolchain-funcs linux-mod

DESCRIPTION="kernel drivers for intel ixp4xx systems (like the NSLU2)"
HOMEPAGE="http://www.intel.com/design/network/products/npfamily/ixp420.htm"
SRC_URI="ftp://aiedownload.intel.com/df-support/9515/eng/IPL_ixp400AccessLibrary-2_1.zip
	ftp://aiedownload.intel.com/df-support/9517/eng/IPL_ixp400NpeLibrary-2_1.zip
	ftp://aiedownload.intel.com/df-support/9519/eng/GPL_ixp400LinuxEthernetDriverPatch-1_5.zip"

LICENSE="ixp4xx"
SLOT="0"
KEYWORDS="-* arm"
IUSE=""
RESTRICT="mirror"

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/ixp400_xscale_sw

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/2.1/*.patch
}

src_compile() {
	cd ixp400_xscale_sw
	local ix_target
	[[ $(printf "#include <endian.h>\n#if __BYTE_ORDER == __LITTLE_ENDIAN\nlittle\n#else\nbig\n#endif\n" | $(tc-getCPP) - | tail -n 1) == "little" ]] \
		&& ix_target=linuxle \
		|| ix_target=linuxbe
	make \
		LINUX_CROSS_COMPILE=${CHOST}- \
		${ix_target}_KERNEL_DIR=${KERNEL_DIR} \
		IX_XSCALE_SW=${PWD} \
		IX_TARGET=${ix_target} \
		IX_DEVICE=ixp42X \
		IX_PLATFORM=ixdp42x \
		COMPONENTS="qmgr npeMh npeDl ethAcc ethDB ethMii featureCtrl osServices oslinux" \
		IX_INCLUDE_MICROCODE=1 \
		ixp400.${KV_OBJ} ixp400_eth.${KV_OBJ} \
		|| die "failed to build kernel modules"
	cp lib/${ix_target}/ixp400.${KV_OBJ} lib/${ix_target}/ixp400_eth.${KV_OBJ} . || die
}

src_install() {
	MODULE_NAMES="ixp400(kernel/drivers/ixp400:${S}) ixp400_eth(kernel/drivers/net:${S})"
	linux-mod_src_install
}
