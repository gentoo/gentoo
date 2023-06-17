# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson

DESCRIPTION="OpenGL Mathematics (glm) for C"
HOMEPAGE="https://github.com/recp/cglm"
SRC_URI="https://github.com/recp/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

src_configure() {
	local emesonargs=(
		"-Dwerror=false"
		$(meson_use test build_tests)
	)
	meson_src_configure
}
