# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Support for parallel scientific applications"
HOMEPAGE="http://www.p4est.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cburstedde/${PN}.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/cburstedde/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="debug examples mpi openmp threads"

RDEPEND="
	sys-apps/util-linux
	sys-libs/zlib
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[romio] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-set_version.patch
	"${FILESDIR}"/${P}-fix_build_system.patch
	"${FILESDIR}"/${P}-fix_cmake_path.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# avoid using debug codepaths that are manually enabled with the
	# RelWithDebInfo build type
	local CMAKE_BUILD_TYPE="Release"

	local mycmakeargs=(
		-Dmpi="$(usex mpi)"
		-Dopenmp="$(usex openmp)"
		-Dlibrary_reldir="$(get_libdir)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

#      rm -r "${ED}"/usr/include/getopt.h \
#          "${ED}"/usr/include/getopt_int.h \
#          "${ED}"/usr/include/sc_builtin || die "rm failed"

	mv "${ED}"/usr/share/docs/SC/* "${ED}"/usr/share/doc/${PF}/ || die "mv failed"
	rm -r "${ED}"/usr/share/docs || die "rm failed"
}
