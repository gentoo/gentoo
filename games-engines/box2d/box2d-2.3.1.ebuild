# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson multilib

MY_PN="Box2D"
DESCRIPTION="A C++ engine for simulating rigid bodies in 2D games"
HOMEPAGE="https://box2d.org/"
SRC_URI="https://github.com/erincatto/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ZLIB"
SLOT="$(ver_cut 1-2).0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}-${PV}/${MY_PN}"

src_prepare() {
	# This version supports CMake but upstream has dropped it since this
	# release. They now use Premake but this Meson file is actually
	# simpler! Installation is manual but that's true for Premake too.
	cat > meson.build <<EOF || die
project('${MY_PN}', 'cpp')
shared_library(
	'${MY_PN}',
	$(find ${MY_PN} -name "*.cpp" -printf "'%p', ")
	soversion: '${SLOT}', install : true
)
EOF

	default
}

src_install() {
	dodoc {Changes,Readme}.txt
	dolib.so "${BUILD_DIR}"/lib${MY_PN}$(get_libname ${SLOT})

	local FILE
	for FILE in $(find ${MY_PN} -name *.h); do
		insinto "/usr/include/${MY_PN}-${SLOT}/${FILE%/*}"
		doins "${FILE}"
	done
}
