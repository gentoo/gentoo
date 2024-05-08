# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Regenerating vkroots.h from the system vk.xml may seem like a good idea,
# especially given that vkroots.h includes some Vulkan headers, but this has led
# to issues such as https://github.com/ValveSoftware/gamescope/issues/858.
# Leaving the code commented in case we need to revert to the earlier approach.

# PYTHON_COMPAT=( python3_{10..11} )

# inherit meson python-any-r1

inherit meson

COMMIT="5106d8a0df95de66cc58dc1ea37e69c99afc9540"
DESCRIPTION="Simple framework for writing Vulkan layers"
HOMEPAGE="https://github.com/Joshua-Ashton/vkroots"
SRC_URI="https://github.com/Joshua-Ashton/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"
LICENSE="Apache-2.0 MIT LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

# BDEPEND="
# 	${PYTHON_DEPS}
# 	dev-util/vulkan-headers
# "

RDEPEND="
	dev-util/vulkan-headers
"

# src_compile() {
# 	"${PYTHON}" ./gen/make_vkroots --xml "${BROOT}"/usr/share/vulkan/registry/vk.xml || die
# }
