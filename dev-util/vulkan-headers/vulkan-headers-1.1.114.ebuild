# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-Headers.git"
	inherit git-r3
else
	EGIT_COMMIT="e3f96a9ccab9397481eb81c4d9bce4ea7590dc33"
	KEYWORDS="amd64 x86"
	SRC_URI="https://github.com/KhronosGroup/Vulkan-Headers/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Vulkan-Headers-${EGIT_COMMIT}"
fi

DESCRIPTION="Vulkan Header files and API registry"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Headers"

LICENSE="Apache-2.0"
SLOT="0"
