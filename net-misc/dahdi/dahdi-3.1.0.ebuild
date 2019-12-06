# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic linux-mod toolchain-funcs

MY_P="${P/dahdi/dahdi-linux}"
JNET=1.0.14
GENTOO=3.1.0
S="${WORKDIR}/${MY_P}"

JNET_DRIVERS="cwain qozap ztgsm"

DESCRIPTION="Kernel modules for Digium compatible hardware (formerly known as Zaptel)"
HOMEPAGE="https://www.asterisk.org"
SRC_URI="https://downloads.asterisk.org/pub/telephony/dahdi-linux/releases/${MY_P}.tar.gz
	https://www.junghanns.net/downloads/jnet-dahdi-drivers-${JNET}.tar.gz
	https://downloads.uls.co.za/gentoo/dahdi/gentoo-dahdi-patchset-${GENTOO}.tar.bz2
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fwload-vpmadt032-1.25.0.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-a4a-a0017.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-a4b-d001e.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-a8a-1d0017.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-a8b-1f001e.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-hx8-2.06.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-032-1.05.01.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-064-1.05.01.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-128-1.05.01.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-256-1.05.01.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-tc400m-MR6.12.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-te133-7a001e.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-te134-780017.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-te435-13001e.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-te436-10017.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-te820-1.76.tar.gz
	https://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-vpmoct032-1.12.0.tar.gz
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="flash oslec"

DEPEND=""
RDEPEND=""

PATCHES=( "${WORKDIR}/dahdi-patchset" )

CONFIG_CHECK="MODULES ~CRC_CCITT"

pkg_pretend() {
	use oslec && CONFIG_CHECK+=" ECHO"
	check_extra_config
}

src_unpack() {
	unpack ${A}
	# Copy the firmware tarballs over, the makefile will try and download them otherwise
	for file in ${A} ; do
		[[ "${file}" = dahdi-fw* ]] || continue
		cp "${DISTDIR}"/${file} "${MY_P}"/drivers/dahdi/firmware/ ||
			die "Error copying ${file} to ${S}/${MY_P}/drivers/dahdi/firmware/"
	done
	# But without the .bin's it'll still fall over and die, so copy those too.
	mv *.bin "${MY_P}"/drivers/dahdi/firmware/ ||
		die "Error moving firmware files into the right folders."

	for drv in ${JNET_DRIVERS}; do
		ln "${WORKDIR}/jnet-dahdi-drivers-${JNET}/${drv}/${drv}.c" "${MY_P}/drivers/dahdi/" ||
			die "Error linking ${drv}.c from jnet to DAHDI."
		ln "${WORKDIR}/jnet-dahdi-drivers-${JNET}/${drv}/${drv}.h" "${MY_P}/drivers/dahdi/" ||
			die "Error linking ${drv}.h from jnet to DAHDI."
	done
}

src_prepare() {
	if use flash; then
		sed -i -e "s:/\* #define FXSFLASH \*/:#define FXSFLASH:" include/dahdi/dahdi_config.h ||
			die "Failed to define FXSFLASH"
		sed -i -e "s:/\* #define SHORT_FLASH_TIME \*/:#define SHORT_FLASH_TIME:" \
			include/dahdi/dahdi_config.h || die "Failed to define SHORT_FLASH_TIME"
	fi
	if use oslec; then
		sed -i -e 's:^#include .*oslec[.]h:#include "/usr/src/linux/drivers/misc/echo/oslec.h:' \
			drivers/dahdi/dahdi_echocan_oslec.c || die "Failed to prepare oslec source files."
	fi
	default
}

src_compile() {
	unset ARCH
	emake V=1 CC="$(tc-getCC)" LD="$(tc-getLD)" KSRC="${KV_OUT_DIR}" \
		DAHDI_MODULES_EXTRA="${JNET_DRIVERS// /.o }.o$(usex oslec " dahdi_echocan_oslec.o" "")" \
		LDFLAGS="$(raw-ldflags)" all
}

src_install() {
	einfo "Installing kernel module"
	emake V=1 CC="$(tc-getCC)" LD="$(tc-getLD)" KSRC="${KV_OUT_DIR}" DESTDIR="${D}" \
		DAHDI_MODULES_EXTRA="${JNET_DRIVERS// /.o }.o$(usex oslec " dahdi_echocan_oslec.o" "")" \
		LDFLAGS="$(raw-ldflags)" install

	rm -r "${ED}"/lib/modules/*/modules.* || die "Error removing bogus modules"
}
