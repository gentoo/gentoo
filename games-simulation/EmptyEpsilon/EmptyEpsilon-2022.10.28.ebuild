# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

# basis_universal version
MY_BU_VER="1_15_update2"
# meshoptimizer version
MY_MO_VER="0.16"

DESCRIPTION="A spaceship bridge simulator game"
HOMEPAGE="https://daid.github.io/EmptyEpsilon/"
# This bundles SeriousProton as the build system does not support using
# a separate SeriousProton instance (and currently EmptyEpsilon seems to
# be the only consumer).
SRC_URI="
	https://github.com/daid/EmptyEpsilon/archive/EE-${PV}.tar.gz -> EmptyEpsilon-${PV}.tar.gz
	https://github.com/daid/SeriousProton/archive/EE-${PV}.tar.gz -> SeriousProton-${PV}.tar.gz
	https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v${MY_BU_VER}.tar.gz -> basis_universal_${MY_BU_VER}.tar.gz
	https://github.com/zeux/meshoptimizer/archive/refs/tags/v${MY_MO_VER}.tar.gz -> meshoptimizer-${MY_MO_VER}.tar.gz
"

# EmptyEpsilon is mostly licensed under GPL, however the art ressources
# use Creative Commons and the bundled SeriousProton is MIT-licensed.
LICENSE="Apache-2.0 GPL-2 CC-BY-SA-3.0 MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-cpp/nlohmann_json
	media-libs/freetype
	media-libs/libsdl2
	>=media-libs/glm-0.9.9.8
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/EmptyEpsilon-EE-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-cmake-meshoptimizer.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} == "binary" ]] && return

	if tc-is-gcc; then
		if [[ $(gcc-major-version) -lt 11 ]]; then
			# ld: /usr/lib64/libsfml-audio.so: undefined reference to `std::__throw_bad_array_new_length()@GLIBCXX_3.a4.29'
			eerror "${PN} requires GCC >= 11. Run gcc-config to switch your default compiler."
			die "Need at least GCC >= 11"
		fi
	fi
}

src_prepare() {
	cmake_src_prepare

	local -A externals=()
	externals["${BUILD_DIR}/SeriousProton/externals/basis"]="${WORKDIR}/basis_universal-${MY_BU_VER}"
	externals["${BUILD_DIR}/externals/meshoptimizer"]="${WORKDIR}/meshoptimizer-${MY_MO_VER}"
	local link
	for link in "${!externals[@]}"; do
		local external_dir=$(dirname "${link}")
		if [[ ! -d "${external_dir}" ]]; then
			mkdir -p "${external_dir}" || die
		fi
		local target="${externals[${link}]}"
		ln -rs "${target}" "${link}" || die
	done

	local serious_proton_patches=(
		"${FILESDIR}/SeriousProton-cmake.patch"
	)
	eapply --directory="${WORKDIR}/SeriousProton-EE-${PV}" \
		   "${serious_proton_patches[@]}"
}

src_configure() {
	local version=( $(ver_rs 1- ' ') )
	local mycmakeargs=(
		-DSERIOUS_PROTON_DIR="${WORKDIR}/SeriousProton-EE-${PV}/"
		-DCPACK_PACKAGE_VERSION="${PV}"
		-DCPACK_PACKAGE_VERSION_MAJOR="${version[0]}"
		-DCPACK_PACKAGE_VERSION_MINOR="${version[1]}"
		-DCPACK_PACKAGE_VERSION_PATCH="${version[2]}"
	)

	cmake_src_configure
}
