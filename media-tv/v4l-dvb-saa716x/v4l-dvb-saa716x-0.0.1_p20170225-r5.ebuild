# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info linux-mod

DESCRIPTION="driver for saa716x based dvb cards like TT S2-6400 or Skystar 2 eXpress HD"
HOMEPAGE="https://bitbucket.org/powARman/v4l-dvb-saa716x"

REVISION="83f3bfd93a95"
REVISION_DATE="20160322"

SRC_URI="https://bitbucket.org/powARman/v4l-dvb-saa716x/get/${REVISION}.tar.bz2
-> v4l-dvb-saa716x-0.0.1_p${REVISION_DATE}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="sys-firmware/tt-s2-6400-firmware"

S="${WORKDIR}/powARman-v4l-dvb-saa716x-${REVISION}"

BUILD_TARGETS="modules"
MODULE_NAMES="
	saa716x_ff(misc:${EROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)
	saa716x_core(misc:${EROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)
	saa716x_budget(misc:${EROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)
	saa716x_hybrid(misc:${EROOT}/usr/src/linux:${S}/linux/drivers/media/common/saa716x)"

CONFIG_CHECK="DVB_CORE DVB_STV6110x DVB_STV090x"

src_prepare() {
	default

	kernel_is ge 4 4 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-up-to-4.4.patch"
	kernel_is ge 4 9 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-up-to-4.9.patch"
	kernel_is ge 4 14 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-up-to-4.14.patch"
	kernel_is ge 4 17 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-up-to-4.17.patch"
	kernel_is ge 5 6 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-5.6-fix-compile.patch"
}

src_compile() {
	kernel_is le 5 0 && BUILD_PARAMS="SUBDIRS" || BUILD_PARAMS="M"
	BUILD_PARAMS+="=${S}/linux/drivers/media/common/saa716x CONFIG_SAA716X_CORE=m \
		CONFIG_DVB_SAA716X_FF=m CONFIG_DVB_SAA716X_BUDGET=m CONFIG_DVB_SAA716X_HYBRID=m"
	addpredict /usr/src/linux/
	linux-mod_src_compile
}
