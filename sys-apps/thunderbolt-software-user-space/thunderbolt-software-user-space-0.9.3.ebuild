# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils linux-info
DESCRIPTION="Thunderbolt(TM) user-space components"
HOMEPAGE="https://github.com/intel/thunderbolt-software-user-space"
SRC_URI="https://github.com/intel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
app-text/txt2tags
dev-libs/boost
"
RDEPEND="${DEPEND}"

pkg_pretend() {
	CONFIG_CHECK="THUNDERBOLT"
	ERROR_THUNDERBOLT="This program talks to the thunderbolt kernel driver, so please enable it."
	CONFIG_CHECK="HOTPLUG_PCI"
	ERROR_HOTPLUG_PCI="Thunderpolt needs pci hotplug support, so please enable it."
	check_extra_config
}
