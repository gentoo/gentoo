# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-Headers.git"
	inherit git-r3
else
	EGIT_COMMIT="b1577d5fbd5424c863710aa156aaafa77cae3de8"
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/KhronosGroup/Vulkan-Headers/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Vulkan-Headers-${EGIT_COMMIT}"
fi

DESCRIPTION="Vulkan Header files and API registry"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Headers"

LICENSE="Apache-2.0"
SLOT="0"

# Old packaging will cause file collisions
RDEPEND="!<=media-libs/vulkan-loader-1.1.70.0-r999"
