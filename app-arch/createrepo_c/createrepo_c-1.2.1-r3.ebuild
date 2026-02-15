# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C implementation of createrepo"
HOMEPAGE="https://github.com/rpm-software-management/createrepo_c"
if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rpm-software-management/createrepo_c.git"
else
	SRC_URI="
		https://github.com/rpm-software-management/createrepo_c/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/rpm-software-management/createrepo_c/commit/4e37bc582b1673ff767dbd0b570ef1c8871d3e8c.patch
			-> ${PN}-1.2.1-r2-rpm6compat.patch
		https://github.com/rpm-software-management/createrepo_c/commit/89fa02828cdaf1c710c38bde5fcbcf59538a9cce.patch
			-> ${PN}-1.2.1-r2-cmake4.patch
		https://github.com/rpm-software-management/createrepo_c/commit/908e3a4a5909ab107da41c2631a06c6b23617f3c.patch
			-> ${PN}-1.2.1-r3-docs-target.patch
		https://github.com/rpm-software-management/createrepo_c/commit/e2ce40a8191b76165a68289bb3a9876171f42dea.patch
			-> ${PN}-1.2.1-r3-docs-doxygen-optional.patch
	"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="doc legacy test zstd"
RESTRICT="!test? ( test )"

BDEPEND="doc? (
	app-text/doxygen
)"

DEPEND="
	app-arch/bzip2:=
	app-arch/drpm
	app-arch/rpm
	app-arch/xz-utils
	app-arch/zchunk
	app-arch/zstd:=
	>=dev-db/sqlite-3.6.18:3
	dev-libs/glib:2
	dev-libs/libxml2:=
	dev-libs/openssl:=
	net-misc/curl
	sys-apps/file
	sys-libs/libmodulemd
	virtual/zlib:=
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${DISTDIR}/createrepo_c-1.2.1-r2-cmake4.patch"
	"${DISTDIR}/createrepo_c-1.2.1-r2-rpm6compat.patch"
	"${FILESDIR}/createrepo_c-1.2.1-r3-cmake-fixes.patch"
	"${DISTDIR}/createrepo_c-1.2.1-r3-docs-target.patch"
	"${DISTDIR}/createrepo_c-1.2.1-r3-docs-doxygen-optional.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_DRPM=ON
		# As best I can tell, this enables distribution as a wheel. No need for this on gentoo!
		-DENABLE_PYTHON=OFF
		# Upstream enables some 'Legacy' stuff by default, let's put that behind a USE flag
		-DENABLE_LEGACY_WEAKDEPS=$(usex legacy ON OFF)
		-DWITH_LEGACY_HASHES=$(usex legacy ON OFF)
		-DWITH_LIBMODULEMD=ON
		-DWITH_ZCHUNK=ON
		-DBUILD_DOC_C=$(usex doc ON OFF)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	# Tests have a magic target!
	use test && cmake_src_compile tests
	use doc && cmake_src_compile doc-c
}

src_test() {
	"${S}"_build/tests/run_tests.sh || die "Failed to run C library tests"
}

src_install() {
	cmake_src_install
	use doc && dodoc -r "${BUILD_DIR}/doc/html"
}
