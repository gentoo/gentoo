# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1
DESCRIPTION="driver for saa716x based dvb cards like TT S2-6400 or Skystar 2 eXpress HD"
HOMEPAGE="https://bitbucket.org/powARman/v4l-dvb-saa716x"
REVISION="83f3bfd93a95"
REVISION_DATE="20160322"
SRC_URI="https://bitbucket.org/powARman/v4l-dvb-saa716x/get/${REVISION}.tar.bz2
-> ${PN}-0.0.1_p${REVISION_DATE}.tar.bz2"
S="${WORKDIR}/powARman-v4l-dvb-saa716x-${REVISION}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="sys-firmware/tt-s2-6400-firmware"

CONFIG_CHECK="DVB_CORE DVB_STV6110x DVB_STV090x"

src_prepare() {
	default

	eapply "${FILESDIR}/v4l-dvb-saa716x-up-to-5.6.patch"
	kernel_is ge 5 18 0 && eapply "${FILESDIR}/v4l-dvb-saa716x-5.18-fix-compile.patch"
}

src_compile() {
	local modlist=(
		saa716x_core=misc:/usr/src/linux:./linux/drivers/media/common/saa716x
		saa716x_ff=misc:/usr/src/linux:./linux/drivers/media/common/saa716x
		saa716x_budget=misc:/usr/src/linux:./linux/drivers/media/common/saa716x
		saa716x_hybrid=misc:/usr/src/linux:./linux/drivers/media/common/saa716x
	)
	local modargs=(
		M="${S}/linux/drivers/media/common/saa716x"
		CONFIG_SAA716X_CORE=m
		CONFIG_DVB_SAA716X_FF=m
		CONFIG_DVB_SAA716X_BUDGET=m
		CONFIG_DVB_SAA716X_HYBRID=m
	)
	linux-mod-r1_src_compile
}
