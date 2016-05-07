# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-info linux-mod

DESCRIPTION="driver for saa716x based dvb cards like Technotrend S2-6400 or Technisat Skystar 2 eXpress HD"
HOMEPAGE="https://bitbucket.org/powARman/v4l-dvb-saa716x/overview"

HG_REVISION="d7e98fc59230"
HG_REVISION_DATE="20141109"

SRC_URI="https://bitbucket.org/powARman/v4l-dvb-saa716x/get/${HG_REVISION}.tar.gz
-> v4l-dvb-saa716x-0.0.1_p${HG_REVISION_DATE}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+firmware"

DEPEND=""
RDEPEND="${DEPEND}
	firmware? ( sys-firmware/tt-s2-6400-firmware )"

S="${WORKDIR}/powARman-v4l-dvb-saa716x-${HG_REVISION}"

BUILD_TARGETS="modules"
MODULE_NAMES="saa716x_ff(misc:${ROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)
	saa716x_core(misc:${ROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)
	saa716x_budget(misc:${ROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)
	saa716x_hybrid(misc:${ROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)"

CONFIG_CHECK="DVB_CORE DVB_STV6110x DVB_STV090x"

src_prepare() {
	default

	eapply -p0 "${FILESDIR}/OSD_RAW_CMD_patch_2.diff"
	eapply "${FILESDIR}/v4l-dvb-saa716x-Makefilepatch-2.diff"
	kernel_is ge 3 19 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-3.19-set_gpio.patch"
	kernel_is ge 4 2 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.2-fix-compile.patch"
	kernel_is ge 4 5 2 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.5.2-fix-compile.patch"
}

src_compile() {
	BUILD_PARAMS="SUBDIRS=${S}/linux/drivers/media/common/saa716x \
	CONFIG_SAA716X_CORE=m CONFIG_DVB_SAA716X_FF=m CONFIG_DVB_SAA716X_BUDGET=m \
	CONFIG_DVB_SAA716X_HYBRID=m"
	addpredict "${ROOT}"/usr/src/linux/
	linux-mod_src_compile
}
