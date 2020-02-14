# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/ECP-VeloC/${PN}.git"
	inherit git-r3
	KEYWORDS=""
	;;
*)
	SRC_URI="https://github.com/ECP-VeloC/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	;;
esac

DESCRIPTION="KVTree provides a fully extensible C data structure modeled after Perl hashes."
HOMEPAGE="https://github.com/ECP-VeloC/KVTree"

LICENSE="MIT"
SLOT="0"
IUSE="fcntl +flock mpi test"

REQUIRED_USE="
		?? ( fcntl flock )
"
RESTRICT="test? ( userpriv ) !test? ( test )"

RDEPEND="
	mpi? ( virtual/mpi )
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/cmake-2.8
	app-admin/chrpath
"

src_prepare() {
	#do not build static library
	sed -i '/kvtree-static/d' src/CMakeLists.txt || die
	#do not install README.md automatically
	sed -i '/FILES README.md DESTINATION/d' CMakeLists.txt || die
	default
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DMPI="$(usex mpi ON OFF)"
		-DKVTREE_FILE_LOCK="$(usex flock FLOCK $(usex fcntl FCNTL NONE))"
	)

	cmake-utils_src_configure
}

src_install() {
	chrpath -d "${BUILD_DIR}/src/kvtree_print_file" || die
	cmake-utils_src_install
	chrpath -d "${ED}/usr/$(get_libdir)/libkvtree.so" || die
	dodoc doc/rst/*.rst
	docinto "${DOCSDIR}/users"
	dodoc -r doc/rst/users/.
}
