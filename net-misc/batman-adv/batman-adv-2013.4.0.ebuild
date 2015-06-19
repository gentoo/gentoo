# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/batman-adv/batman-adv-2013.4.0.ebuild,v 1.1 2013/11/24 22:57:51 xmw Exp $

EAPI=4

CONFIG_CHECK="~!CONFIG_BATMAN_ADV"
MODULE_NAMES="${PN}(net:${S}:${S})"
BUILD_TARGETS="all"

inherit eutils linux-mod

DESCRIPTION="Better approach to mobile Ad-Hoc networking on layer 2 kernel module"
HOMEPAGE="http://www.open-mesh.org/"
SRC_URI="http://downloads.open-mesh.org/batman/stable/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bla dat debug nc"

DEPEND=""
RDEPEND=""

src_compile() {
	BUILD_PARAMS="CONFIG_BATMAN_ADV_DEBUG=$(usex debug y n)"
	BUILD_PARAMS+=" CONFIG_BATMAN_ADV_BLA=$(usex bla y n)"
	BUILD_PARAMS+=" CONFIG_BATMAN_ADV_DAT=$(usex dat y n)"
	BUILD_PARAMS+=" CONFIG_BATMAN_ADV_NC=$(usex nc y n)"
	export BUILD_PARAMS
	export KERNELPATH="${KERNEL_DIR}"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
	dodoc README CHANGELOG
}
