# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod

DESCRIPTION="driver for saa716x based dvb cards like TT S2-6400 or Skystar 2 eXpress HD"
HOMEPAGE="https://bitbucket.org/powARman/v4l-dvb-saa716x/overview"

HG_REVISION="3b9fce66666a"
HG_REVISION_DATE="20160322"

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
MODULE_NAMES="
	saa716x_ff(misc:${EROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)
	saa716x_core(misc:${EROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)
	saa716x_budget(misc:${EROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)
	saa716x_hybrid(misc:${EROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)"

CONFIG_CHECK="DVB_CORE DVB_STV6110x DVB_STV090x"

src_prepare() {
	default

	eapply -p0 "${FILESDIR}/OSD_RAW_CMD_patch_2.diff"
	eapply "${FILESDIR}/v4l-dvb-saa716x-Makefilepatch-2.diff"
	kernel_is ge 3 19 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-3.19-set_gpio.patch"
	kernel_is ge 4 2 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.2-fix-compile.patch"
	kernel_is ge 4 5 2 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.5.2-fix-compile.patch"
	kernel_is ge 4 6 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.6.0-fix-compile.patch"
	kernel_is ge 4 9 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.9-fix-warnings.patch"
	kernel_is ge 4 10 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.10-fix-compile.patch"
	kernel_is ge 4 14 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.14.0-fix-compile.patch"
	kernel_is ge 4 15 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.15-fix-autorepeat.patch"
	kernel_is ge 4 15 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.15-fix-timers.patch"
	kernel_is ge 4 16 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.16-fix-compile.patch"
	kernel_is ge 4 17 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-4.17-define-AUDIO_GET_PTS.patch"
}

src_compile() {
	kernel_is le 5 0 && BUILD_PARAMS="SUBDIRS" || BUILD_PARAMS="M"
	BUILD_PARAMS+="=${S}/linux/drivers/media/common/saa716x CONFIG_SAA716X_CORE=m \
		CONFIG_DVB_SAA716X_FF=m CONFIG_DVB_SAA716X_BUDGET=m CONFIG_DVB_SAA716X_HYBRID=m"
	addpredict "${EROOT}"/usr/src/linux/
	linux-mod_src_compile
}
