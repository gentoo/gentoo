# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

PARMASAN_COMMIT="a313a554e2e288764b6f83761416c90990a00cee"
DESCRIPTION="Parallel make sanitizer"
HOMEPAGE="https://github.com/ispras/parmasan"
SRC_URI="https://github.com/ispras/parmasan/archive/${PARMASAN_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-${PARMASAN_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-build/parmasan-remake"

src_install() {
	cmake_src_install

	# Let's make it less likely to collide and it's then common
	# with parmasan-remake.
	mv "${ED}"/usr/bin/{,parmasan-}tracer || die
}
