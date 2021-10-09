# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="A spaceship bridge simulator game."
HOMEPAGE="https://daid.github.io/EmptyEpsilon/"
# This bundles SeriousProton as the build system does not support using
# a separate SeriousProton instance (and currently EmptyEpsilon seems to
# be the only consumer).
SRC_URI="https://github.com/daid/EmptyEpsilon/archive/EE-${PV}.tar.gz -> EmptyEpsilon-${PV}.tar.gz
	https://github.com/daid/SeriousProton/archive/EE-${PV}.tar.gz -> SeriousProton-${PV}.tar.gz"

# EmptyEpsilon is mostly licensed under GPL, however the art ressources
# use Creative Commons and the bundled SeriousProton is MIT-licensed.
LICENSE="GPL-2 CC-BY-SA-3.0 MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-cpp/json11-1.0.0
	media-libs/libglvnd
	media-libs/libsfml
	>=media-libs/glm-0.9.9.8
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/EmptyEpsilon-EE-${PV}"

pkg_pretend() {
	if [[ ${MERGE_TYPE} == "binary" ]]; then
		return
	fi

	if tc-is-gcc; then
		if [[ $(gcc-major-version) -lt 11 ]]; then
			# ld: /usr/lib64/libsfml-audio.so: undefined reference to `std::__throw_bad_array_new_length()@GLIBCXX_3.a4.29'
			eerror "${PN} requires GCC >= 11. Run gcc-config to switch your default compiler."
			die "Need at least GCC >= 11"
		fi
	fi
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-Make-CMake-call-find_package-glm.patch"
	eapply --directory="${WORKDIR}/SeriousProton-EE-${PV}" \
		   "${FILESDIR}/SeriousProton-Unbundle-json11.patch"

	eapply_user

	cmake_src_prepare
}

src_configure() {
	local version=( $(ver_rs 1- ' ') )
	local mycmakeargs=(
		-DSERIOUS_PROTON_DIR="${WORKDIR}/SeriousProton-EE-${PV}/"
		-DOpenGL_GL_PREFERENCE=GLVND
		-DCPACK_PACKAGE_VERSION="${PV}"
		-DCPACK_PACKAGE_VERSION_MAJOR="${version[0]}"
		-DCPACK_PACKAGE_VERSION_MINOR="${version[1]}"
		-DCPACK_PACKAGE_VERSION_PATCH="${version[2]}"
	)

	cmake_src_configure
}
