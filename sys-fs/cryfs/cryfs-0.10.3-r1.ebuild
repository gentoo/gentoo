# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
inherit cmake flag-o-matic linux-info python-any-r1

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cryfs/cryfs"
else
	SRC_URI="https://github.com/cryfs/cryfs/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
	S="${WORKDIR}"
fi

DESCRIPTION="Encrypted FUSE filesystem that conceals metadata"
HOMEPAGE="https://www.cryfs.org/"

LICENSE="LGPL-3 MIT"
SLOT="0"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	>=dev-libs/crypto++-8.2.0:=
	net-misc/curl:=
	>=sys-fs/fuse-2.8.6:0
	dev-libs/openssl:=
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/versioneer[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	# TODO upstream:
	"${FILESDIR}/${PN}-0.10.2-unbundle-libs.patch"
	"${FILESDIR}/${PN}-0.10.2-install-targets.patch"
	"${FILESDIR}/${PN}-0.10.3-gcc13.patch"
	# From upstream
	"${FILESDIR}/${PN}-0.10.3-gcc11.patch"
	"${FILESDIR}/${PN}-0.10.3-fix-build-with-boost-1-77.patch"
)

python_check_deps() {
	python_has_version "dev-python/versioneer[${PYTHON_USEDEP}]"
}

pkg_setup() {
	local CONFIG_CHECK="~FUSE_FS"
	local WARNING_FUSE_FS="CONFIG_FUSE_FS is required for cryfs support."

	check_extra_config
	python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# don't install compressed manpage
	cmake_comment_add_subdirectory doc

	# We use the package instead for >=py3.12 compat, bug #908997
	rm src/gitversion/versioneer.py || die

	# remove tests that require internet access to comply with Gentoo policy
	sed -e "/CurlHttpClientTest.cpp/d" -e "/FakeHttpClientTest.cpp/d" \
		-i test/cpp-utils/CMakeLists.txt || die

	# /dev/fuse access denied
	sed -e "/CliTest_IntegrityCheck/d" \
		-i test/cryfs-cli/CMakeLists.txt || die
}

src_configure() {
	# ODR violations (bug #880563)
	filter-lto

	local mycmakeargs=(
		-DBoost_USE_STATIC_LIBS=OFF
		-DCRYFS_UPDATE_CHECKS=OFF
		-DBUILD_SHARED_LIBS=OFF
		-DUSE_SYSTEM_LIBS=ON
		-DBUILD_TESTING=$(usex test)
	)

	use debug || append-flags -DNDEBUG

	# bug 907096
	use elibc_musl && append-flags -D_LARGEFILE64_SOURCE

	cmake_src_configure
}

src_test() {
	local TMPDIR="${T}"
	local tests_failed=()

	# fspp fuse tests hang, bug # 699044
	for i in gitversion cpp-utils parallelaccessstore blockstore blobstore cryfs cryfs-cli ; do
		"${BUILD_DIR}"/test/${i}/${i}-test || tests_failed+=( "${i}" )
	done

	if [[ -n ${tests_failed[@]} ]] ; then
		eerror "The following tests failed:"
		eerror "${tests_failed[@]}"
		die "At least one test failed"
	fi
}

src_install() {
	cmake_src_install
	doman doc/man/cryfs.1
}
