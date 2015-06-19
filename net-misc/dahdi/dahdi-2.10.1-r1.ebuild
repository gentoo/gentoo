# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dahdi/dahdi-2.10.1-r1.ebuild,v 1.1 2015/05/14 13:21:16 chainsaw Exp $

EAPI=5

inherit base linux-mod eutils flag-o-matic toolchain-funcs

MY_P="${P/dahdi/dahdi-linux}"
JNET=1.0.14
GENTOO=1.2.1
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Kernel modules for Digium compatible hardware (formerly known as Zaptel)"
HOMEPAGE="http://www.asterisk.org"
SRC_URI="http://downloads.asterisk.org/pub/telephony/dahdi-linux/releases/${MY_P}.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-a4a-a0017.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-a4b-b0019.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-a8a-1d0017.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-a8b-1d0019.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-hx8-2.06.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-032-1.05.01.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-064-1.05.01.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-128-1.05.01.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-256-1.05.01.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-tc400m-MR6.12.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-te133-780019.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-te134-780017.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-te435-e0019.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-te436-10017.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-te820-1.76.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-vpmoct032-1.12.0.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fwload-vpmadt032-1.25.0.tar.gz
mirror://gentoo/gentoo-dahdi-patchset-${GENTOO}.tar.bz2
http://www.junghanns.net/downloads/jnet-dahdi-drivers-${JNET}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flash"
RESTRICT="test"

DEPEND=""
RDEPEND=""

EPATCH_SUFFIX="diff"
PATCHES=( "${WORKDIR}/dahdi-patchset" )

CONFIG_CHECK="MODULES ~CRC_CCITT"

src_unpack() {
	unpack ${A}
	# Copy the firmware tarballs over, the makefile will try and download them otherwise
	for file in ${A} ; do
		cp "${DISTDIR}"/${file} "${MY_P}"/drivers/dahdi/firmware/
	done
	# But without the .bin's it'll still fall over and die, so copy those too.
	cp *.bin "${MY_P}"/drivers/dahdi/firmware/
	cp -p "${WORKDIR}"/jnet-dahdi-drivers-${JNET}/cwain/*.[ch] "${MY_P}"/drivers/dahdi/
	cp -p "${WORKDIR}"/jnet-dahdi-drivers-${JNET}/qozap/*.[ch] "${MY_P}"/drivers/dahdi/
	cp -p "${WORKDIR}"/jnet-dahdi-drivers-${JNET}/ztgsm/*.[ch] "${MY_P}"/drivers/dahdi/
}

src_prepare() {
	if use flash; then
		sed -i -e "s:/\* #define FXSFLASH \*/:#define FXSFLASH:" include/dahdi/dahdi_config.h || die "Failed to define FXSFLASH"
		sed -i -e "s:/\* #define SHORT_FLASH_TIME \*/:#define SHORT_FLASH_TIME:" include/dahdi/dahdi_config.h || die "Failed to define SHORT_FLASH_TIME"
	fi
	base_src_prepare
}

src_compile() {
	unset ARCH
	emake V=1 CC=$(tc-getCC) LD=$(tc-getLD) KSRC="${KV_OUT_DIR}" DESTDIR="${D}" DAHDI_MODULES_EXTRA="cwain.o qozap.o ztgsm.o" all
}

src_install() {
	einfo "Installing kernel module"
	emake V=1 CC=$(tc-getCC) LD=$(tc-getLD) KSRC="${KV_OUT_DIR}" DESTDIR="${D}" DAHDI_MODULES_EXTRA="cwain.o qozap.o ztgsm.o" install
	rm -rf "$D"/lib/modules/*/modules.*
}
