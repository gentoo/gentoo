# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-Headers.git"
	inherit git-r3
else
	if [[ -z ${SNAPSHOT_COMMIT} ]]; then
		MY_PV=v${PV}
		MY_P=Vulkan-Headers-${PV}
	else
		MY_PV=${SNAPSHOT_COMMIT}
		MY_P=Vulkan-Headers-${SNAPSHOT_COMMIT}
	fi
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/KhronosGroup/Vulkan-Headers/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${MY_P}
fi

RDEPEND="!<dev-util/vulkan-tools-1.1.124
	 !<media-libs/vulkan-layers-1.1.125"

DESCRIPTION="Vulkan Header files and API registry"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Headers"

LICENSE="Apache-2.0"
SLOT="0"
