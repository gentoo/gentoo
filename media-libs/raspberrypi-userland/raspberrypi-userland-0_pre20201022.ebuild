# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake flag-o-matic udev

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	SRC_URI=""
else
	#We base our versioning off Raspbian's
	#Go to https://archive.raspberrypi.org/debian/pool/main/r/raspberrypi-userland/
	#Example:
	#libraspberrypi-bin-dbgsym_2+git20201022~151804+e432bc3-1_arm64.deb
	#"e432bc3" is the first 7 hex digits of the commit hash.
	#Now go to https://github.com/raspberrypi/userland/commits/master and find the
	#full hash
	GIT_COMMIT="e432bc3400401064e2d8affa5d1454aac2cf4a00"
	SRC_URI="https://github.com/raspberrypi/userland/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~arm ~arm64"
	S="${WORKDIR}/userland-${GIT_COMMIT}"
fi

DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/userland"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="acct-group/video
	!media-libs/raspberrypi-userland-bin"

#Install in $(get_libdir)
#See https://github.com/raspberrypi/userland/pull/650
PATCHES=( "${FILESDIR}/${PN}-libdir.patch" )
#Don't install includes that collide.
PATCHES+=( "${FILESDIR}/${PN}-include.patch" )
#See https://github.com/raspberrypi/userland/pull/655
PATCHES+=( "${FILESDIR}/${PN}-libfdt-static.patch" )
#See https://github.com/raspberrypi/userland/pull/659
PATCHES+=( "${FILESDIR}/${PN}-pkgconf-arm64.patch" )

pkg_setup() {
	append-ldflags $(no-as-needed)

	mycmakeargs=(
		-DVMCS_INSTALL_PREFIX="/usr"
		-DARM64=$(usex arm64 ON OFF)
	)
}

src_prepare() {
	cmake_src_prepare
	sed -i \
		-e 's:DESTINATION ${VMCS_INSTALL_PREFIX}/src:DESTINATION ${VMCS_INSTALL_PREFIX}/'"share/doc/${PF}:" \
		"${S}/makefiles/cmake/vmcs.cmake" || die "Failed sedding makefiles/cmake/vmcs.cmake"
	sed -i \
		-e 's:^install(TARGETS EGL GLESv2 OpenVG WFC:install(TARGETS:' \
		-e '/^install(TARGETS EGL_static GLESv2_static/d' \
		"${S}/interface/khronos/CMakeLists.txt" || die "Failed sedding interface/khronos/CMakeLists.txt"
}

src_install() {
	cmake_src_install
	udev_dorules "${FILESDIR}/92-local-vchiq-permissions.rules"
}
