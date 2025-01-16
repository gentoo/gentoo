# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit cmake flag-o-matic linux-info python-any-r1

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cryfs/cryfs"
else
	SRC_URI="
		https://github.com/cryfs/cryfs/archive/refs/tags/${PV}.tar.gz
			-> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Encrypted FUSE filesystem that conceals metadata"
HOMEPAGE="https://www.cryfs.org/"

LICENSE="LGPL-3 MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	dev-libs/crypto++:=
	dev-libs/libfmt:=
	dev-libs/spdlog:=
	>=sys-fs/fuse-2.8.6:0
"
DEPEND="
	${RDEPEND}
	dev-cpp/range-v3
	net-misc/curl
	test? (
		dev-cpp/gtest
	)
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	$(python_gen_any_dep '
		dev-python/versioneer[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	# TODO: upstream:
	"${FILESDIR}"/cryfs-1.0.1-unbundle-vendored-libs.patch
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

	# Hook up ctest properly for better maintainer quality of life
	sed -i -e '/option(BUILD_TESTING/aenable_testing()' CMakeLists.txt || die
	sed -i -e '/BUILD_TESTING/a  include(GoogleTest)' test/CMakeLists.txt || die
	sed -i -e 's/add_test/gtest_discover_tests/' test/*/CMakeLists.txt || die
}

src_configure() {
	# ODR violations (bug #880563)
	# ./CMakeLists.txt
	# """
	# We don't use LTO because crypto++ has problems with it,
	# see https://github.com/weidai11/cryptopp/issues/1031 and
	# https://www.cryptopp.com/wiki/Link_Time_Optimization
	# """
	filter-lto

	local mycmakeargs=(
		# Upstream inconsistently specifies their libraries as STATIC
		# Leading to issues when static libraries without PIC are linked
		# with PIC shared libraries.
		-DBUILD_SHARED_LIBS=OFF
		-DBUILD_TESTING=$(usex test)
		-DCRYFS_UPDATE_CHECKS=OFF
		-DUSE_SYSTEM_LIBS=ON
	)

	append-cppflags -DNDEBUG

	# bug 907096
	use elibc_musl && append-flags -D_LARGEFILE64_SOURCE

	cmake_src_configure
}

src_test() {
	local TMPDIR="${T}"

	local CMAKE_SKIP_TESTS=(
		# Cannot test mounting filesystems in sandbox
		# Filesystem did not call onMounted callback, probably wasn't successfully mounted.
		# bug #808849
		CliTest.WorksWithCommasInBasedir
		CliTest_IntegrityCheck.givenIncorrectFilesystemId_thenFails
		CliTest_IntegrityCheck.givenIncorrectFilesystemKey_thenFails
		CliTest_Setup.AutocreateBasedir
		CliTest_Setup.AutocreateMountpoint
		CliTest_Setup.ConfigfileGiven
		CliTest_Setup.ExistingLogfileGiven
		CliTest_Setup.NoSpecialOptions
		CliTest_Setup.NotexistingLogfileGiven
		CliTest_Unmount.givenMountedFilesystem_whenUnmounting_thenSucceeds
		RunningInForeground/CliTest_WrongEnvironment.BaseDir_AllPermissions
		RunningInForeground/CliTest_WrongEnvironment.BaseDir_DoesntExist_Create
		RunningInForeground/CliTest_WrongEnvironment.MountDir_AllPermissions
		RunningInForeground/CliTest_WrongEnvironment.MountDir_DoesntExist_Create
		RunningInForeground/CliTest_WrongEnvironment.NoErrorCondition
		RunningInForeground_ExternalConfigfile/CliTest_WrongEnvironment.BaseDir_AllPermissions
		RunningInForeground_ExternalConfigfile/CliTest_WrongEnvironment.BaseDir_DoesntExist_Create
		RunningInForeground_ExternalConfigfile/CliTest_WrongEnvironment.MountDir_AllPermissions
		RunningInForeground_ExternalConfigfile/CliTest_WrongEnvironment.MountDir_DoesntExist_Create
		RunningInForeground_ExternalConfigfile/CliTest_WrongEnvironment.NoErrorCondition
		RunningInForeground_ExternalConfigfile_LogIsNotStderr/CliTest_WrongEnvironment.BaseDir_AllPermissions
		RunningInForeground_ExternalConfigfile_LogIsNotStderr/CliTest_WrongEnvironment.BaseDir_DoesntExist_Create
		RunningInForeground_ExternalConfigfile_LogIsNotStderr/CliTest_WrongEnvironment.MountDir_AllPermissions
		RunningInForeground_ExternalConfigfile_LogIsNotStderr/CliTest_WrongEnvironment.MountDir_DoesntExist_Create
		RunningInForeground_ExternalConfigfile_LogIsNotStderr/CliTest_WrongEnvironment.NoErrorCondition
		RunningInForeground_LogIsNotStderr/CliTest_WrongEnvironment.BaseDir_AllPermissions
		RunningInForeground_LogIsNotStderr/CliTest_WrongEnvironment.BaseDir_DoesntExist_Create
		RunningInForeground_LogIsNotStderr/CliTest_WrongEnvironment.MountDir_AllPermissions
		RunningInForeground_LogIsNotStderr/CliTest_WrongEnvironment.MountDir_DoesntExist_Create
		RunningInForeground_LogIsNotStderr/CliTest_WrongEnvironment.NoErrorCondition
		# Filesystem did not call onMounted callback, probably wasn't successfully mounted.
		# fuse: failed to open /dev/fuse: Permission denied
		CliTest_IntegrityCheck.givenFilesystemWithRolledBackBasedir_whenMounting_thenFails
		CliTest_IntegrityCheck.whenRollingBackBasedirWhileMounted_thenUnmounts
		# Tests that hang due to being unable to open fuse
		# bug #699044
		# fuse: failed to open /dev/fuse: Permission denied
		Fuse*
	)

	cmake_src_test
}

src_install() {
	cmake_src_install
	doman doc/man/cryfs.1
	doman doc/man/cryfs-unmount.1
}

pkg_postinst() {
	if ver_test "${REPLACING_VERSIONS}" -lt 1.0.0; then
		elog "Filesystems created with CryFS 0.11.x and CryFS 1.0.0 are fully compatible with each other."
		elog "This means filesystems created with 0.10.x or 0.11.x can be mounted without requiring a migration."
		elog "Filesystems created with 1.0.0 or 0.11.x can be mounted by CryFS 0.10.x,"
		elog "but only if you configure it to use a cipher supported by CryFS 0.10.x, e.g. AES-256-GCM."
		elog "The new default, XChaCha20-Poly1305, is not supported by CryFS 0.10.x."
	fi
}
