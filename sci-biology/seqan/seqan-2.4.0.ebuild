# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}

inherit cmake-utils multibuild toolchain-funcs

DESCRIPTION="C++ Sequence Analysis Library"
HOMEPAGE="http://www.seqan.de/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/seqan/seqan.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/seqan/seqan/archive/seqan-v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

	S=${WORKDIR}/seqan-seqan-v${PV}
fi

LICENSE="BSD GPL-3"
SLOT="0"
IUSE="cpu_flags_x86_sse4_1 tools"
REQUIRED_USE="cpu_flags_x86_sse4_1"

RDEPEND="
	app-arch/bzip2:=
	sys-libs/zlib:=
	!!sci-biology/seqan:2.0
	!!sci-biology/seqan:2.1
	!!sci-biology/seqan:2.2"
DEPEND="
	${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-2.4.0-fix-pthread.patch )

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		use tools && tc-check-openmp

		MULTIBUILD_VARIANTS=(
			$(usev tools)
			library
		)
	fi
}

src_configure() {
	my_configure() {
		local mycmakeargs=(
			-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
			-DSEQAN_NO_DOX=ON
		)
		case "${MULTIBUILD_ID}" in
			tools)
				mycmakeargs+=(
					-DSEQAN_BUILD_SYSTEM=SEQAN_RELEASE_APPS
				)
				;;
			library)
				mycmakeargs+=(
					-DSEQAN_BUILD_SYSTEM=SEQAN_RELEASE_LIBRARY
				)
				;;
			*)
				die "${MULTIBUILD_ID} is not recognized"
				;;
		esac
		cmake-utils_src_configure
	}
	multibuild_foreach_variant my_configure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
