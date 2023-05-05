# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="e6b89494142eec0ac6061f82a947d2f1246d3d7a"
DESCRIPTION="Simple framework for writing Vulkan layers"
HOMEPAGE="https://github.com/Joshua-Ashton/vkroots"
SRC_URI="https://github.com/Joshua-Ashton/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
LICENSE="Apache-2.0 MIT LGPL-2.1"
SLOT="0"

RDEPEND="
	dev-util/vulkan-headers
"

S="${WORKDIR}/${PN}-${COMMIT}"

src_install() {
	default
	insinto /usr/include/${PN}
	doins ${PN}.h meson.build
}
