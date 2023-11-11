# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Regenerating vkroots.h from the system vk.xml may seem like a good idea,
# especially given that vkroots.h includes some Vulkan headers, but this has led
# to issues such as https://github.com/ValveSoftware/gamescope/issues/858.
# Leaving the code commented in case we need to revert to the earlier approach.

# PYTHON_COMPAT=( python3_{10..11} )

# inherit meson python-any-r1

inherit meson

COMMIT="d5ef31abc7cb5c69aee4bcb67b10dd543c1ff7ac"
DESCRIPTION="Simple framework for writing Vulkan layers"
HOMEPAGE="https://github.com/Joshua-Ashton/vkroots"
SRC_URI="https://github.com/Joshua-Ashton/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
LICENSE="Apache-2.0 MIT LGPL-2.1"
SLOT="0"

# BDEPEND="
# 	${PYTHON_DEPS}
# 	dev-util/vulkan-headers
# "

RDEPEND="
	dev-util/vulkan-headers
"

S="${WORKDIR}/${PN}-${COMMIT}"

# src_compile() {
# 	"${PYTHON}" ./gen/make_vkroots --xml "${BROOT}"/usr/share/vulkan/registry/vk.xml || die
# }
