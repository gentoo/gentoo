# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

MY_P="${P/dahdi/dahdi-linux}"
JNET=1.0.14
GENTOO_PATCHVERSION=3.2.0
GENTOO_SOURCEVERSION=3.2.0
S="${WORKDIR}/${MY_P}"

JNET_DRIVERS="cwain qozap ztgsm"

DESCRIPTION="Kernel modules for Digium compatible hardware (formerly known as Zaptel)"
HOMEPAGE="https://www.asterisk.org"
SRC_URI="https://downloads.asterisk.org/pub/telephony/dahdi-linux/releases/${MY_P}.tar.gz
	https://www.junghanns.net/downloads/jnet-dahdi-drivers-${JNET}.tar.gz
	https://downloads.uls.co.za/gentoo/dahdi/gentoo-dahdi-patches-${GENTOO_PATCHVERSION}.tar.bz2
	https://downloads.uls.co.za/gentoo/dahdi/gentoo-dahdi-sources-${GENTOO_SOURCEVERSION}.tar.bz2
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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="flash oslec"

PATCHES=(
	"${WORKDIR}/gentoo-dahdi-patches-${GENTOO_PATCHVERSION}"
	"${FILESDIR}"/${PN}-3.2.0-clang-16-build-fix.patch
)

pkg_setup() {
	local CONFIG_CHECK="PCI ~CRC_CCITT"
	use oslec && CONFIG_CHECK+=" ECHO"

	linux-mod-r1_pkg_setup
}

src_unpack() {
	local file drv

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

	# Find the stuff from gentoo-sources (ie, modules that has been removed by
	# upstream and we're re-adding).
	DAHDI_GENTOO_MODULES=""
	for file in "${WORKDIR}/gentoo-dahdi-sources-${GENTOO_SOURCEVERSION}"/*; do
		[[ -d "${file}" ]] && DAHDI_GENTOO_MODULES+=" $(basename "${file}")/"
		[[ -f "${file}" && "${file}" = *.c ]] && DAHDI_GENTOO_MODULES+=" $(basename "${file}" .c).o"
		mv -n "${file}" "${MY_P}/drivers/dahdi/" || die "Move of ${file} into dahdi-drivers failed."
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
	MODULES_MAKEARGS+=(
		KSRC="${KV_OUT_DIR}"
		DAHDI_MODULES_EXTRA="${JNET_DRIVERS// /.o }.o$(usev oslec " dahdi_echocan_oslec.o")${DAHDI_GENTOO_MODULES}"
	)

	emake "${MODULES_MAKEARGS[@]}"
}

src_install() {
	emake "${MODULES_MAKEARGS[@]}" DESTDIR="${ED}" install
	modules_post_process

	# Remove the blank "version" files (these files are all empty, and root owned).
	find "${ED}/lib/firmware" -name ".*" -delete || die "Error removing empty firmware version files"
}
