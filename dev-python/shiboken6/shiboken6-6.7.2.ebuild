# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Split the "/usr/bin/shiboken6" binding generator from the
# "/usr/lib64/libshiboken6-*.so" family of shared libraries. The former
# requires everything (including Clang) at runtime; the latter only requires
# Qt and Python at runtime. Note that "pip" separates these two as well. See:
# https://doc.qt.io/qtforpython/shiboken6/faq.html#is-there-any-runtime-dependency-on-the-generated-binding
# Once split, the PySide6 ebuild should be revised to require
# "/usr/bin/shiboken6" at build time and "libshiboken6-*.so" at runtime.
# TODO: Add PyPy once officially supported. See also:
#     https://bugreports.qt.io/browse/PYSIDE-535
PYTHON_COMPAT=( python3_{10..13} )

LLVM_COMPAT=( {15..18} )

inherit cmake flag-o-matic llvm-r1 python-r1 toolchain-funcs

MY_PN="pyside-setup-everywhere-src"

DESCRIPTION="Python binding generator for C++ libraries"
HOMEPAGE="https://wiki.qt.io/PySide6"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-${PV}-src/${MY_PN}-${PV}.tar.xz"
S="${WORKDIR}/${MY_PN}-${PV}/sources/shiboken6"

# The "sources/shiboken6/libshiboken" directory is triple-licensed under the
# GPL v2, v3+, and LGPL v3. All remaining files are licensed under the GPL v3
# with version 1.0 of a Qt-specific exception enabling shiboken6 output to be
# arbitrarily relicensed. (TODO)
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 ) GPL-3"
SLOT="6/${PV}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+docstrings numpy test vulkan"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Tests fail pretty bad and I'm not fixing them right now
RESTRICT="test"

# Minimal supported version of Qt.
QT_PV="$(ver_cut 1-3)*:6"

# Since Clang is required at both build- and runtime, BDEPEND is omitted here.
RDEPEND="${PYTHON_DEPS}
	=dev-qt/qtbase-${QT_PV}
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
		sys-devel/llvm:${LLVM_SLOT}
	')
	docstrings? (
		>=dev-libs/libxml2-2.6.32
		>=dev-libs/libxslt-1.1.19
	)
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	vulkan? ( dev-util/vulkan-headers )
	!dev-python/shiboken6:0
"
DEPEND="${RDEPEND}
	test? ( =dev-qt/qtbase-${QT_PV}[gui] )
"
# testlib is toggled by the gui flag on qtbase

DOCS=( AUTHORS )

PATCHES=(
	"${FILESDIR}/${PN}-6.3.1-no-strip.patch"
)

src_prepare() {
	# TODO: File upstream issue requesting a sane way to disable NumPy support.
	if ! use numpy; then
		sed -i -e '/\bprint(os\.path\.realpath(numpy))/d' \
			libshiboken/CMakeLists.txt || die
	fi

	# Shiboken6 assumes Vulkan headers live under either "$VULKAN_SDK/include"
	# or "$VK_SDK_PATH/include" rather than "${EPREFIX}/usr/include/vulkan".
	if use vulkan; then
		sed -i -e "s~\bdetectVulkan(&headerPaths);~headerPaths.append(HeaderPath{QByteArrayLiteral(\"${EPREFIX}/usr/include/vulkan\"), HeaderType::System});~" \
			ApiExtractor/clangparser/compilersupport.cpp || die
	fi

	local clangver="$(CPP=clang clang-major-version)"

	# Clang 15 and older used the full version as a directory name.
	if [[ ${clangver} -lt 16 ]]; then
		clangver="$(CPP=clang clang-fullversion)"
	fi

	# Shiboken6 assumes the "/usr/lib/clang/${CLANG_NEWEST_VERSION}/include/"
	# subdirectory provides Clang builtin includes (e.g., "stddef.h") for the
	# currently installed version of Clang, where ${CLANG_NEWEST_VERSION} is
	# the largest version specifier that exists under the "/usr/lib/clang/"
	# subdirectory. This assumption is false in edge cases, including when
	# users downgrade from newer Clang versions but fail to remove those
	# versions with "emerge --depclean". See also:
	#     https://github.com/leycec/raiagent/issues/85
	#
	# Sadly, the clang-* family of functions exported by the "toolchain-funcs"
	# eclass are defective, returning nonsensical placeholder strings if the
	# end user has *NOT* explicitly configured their C++ compiler to be Clang.
	# PySide6 does *NOT* care whether the end user has done so or not, as
	# PySide6 unconditionally requires Clang in either case. See also:
	#     https://bugs.gentoo.org/619490
	sed -i -e 's~(findClangBuiltInIncludesDir())~(QStringLiteral("'"${EPREFIX}"'/usr/lib/clang/'"${clangver}"'/include"))~' \
		ApiExtractor/clangparser/compilersupport.cpp || die

	cmake_src_prepare
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/925479
	# https://bugreports.qt.io/browse/PYSIDE-2619
	filter-lto

	# Minimal tests for now, 2 failing with the extended version
	# FIXME Subscripted generics cannot be used with class and instance checks
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DDISABLE_DOCSTRINGS=$(usex !docstrings)
	)

	shiboken6_configure() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
			-DUSE_PYTHON_VERSION="${EPYTHON#python}"
			-DFORCE_LIMITED_API=OFF
		)
		# CMakeLists.txt expects LLVM_INSTALL_DIR as an environment variable.
		local -x LLVM_INSTALL_DIR="$(get_llvm_prefix)"
		cmake_src_configure
	}
	python_foreach_impl shiboken6_configure
}

src_compile() {
	python_foreach_impl cmake_src_compile
}

src_test() {
	python_foreach_impl cmake_src_test
}

src_install() {
	shiboken6_install() {
		cmake_src_install
		python_optimize

		# Uniquify the "shiboken6" executable for the current Python target,
		# preserving an unversioned "shiboken6" file arbitrarily associated
		# with the last Python target.
		cp "${ED}"/usr/bin/${PN}{,-${EPYTHON}} || die

		# Uniquify the Shiboken6 pkgconfig file for the current Python target,
		# preserving an unversioned "shiboken6.pc" file arbitrarily associated
		# with the last Python target. See also:
		#     https://github.com/leycec/raiagent/issues/73
		cp "${ED}/usr/$(get_libdir)"/pkgconfig/${PN}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl shiboken6_install

	# CMakeLists.txt installs a "Shiboken6Targets-gentoo.cmake" file forcing
	# downstream consumers (e.g., PySide6) to target one "libshiboken6-*.so"
	# library and one "shiboken6" executable linked to one Python interpreter.
	# See also:
	#     https://bugreports.qt.io/browse/PYSIDE-1053
	#     https://github.com/leycec/raiagent/issues/74
	sed -i \
		-e 's~shiboken6-python[[:digit:]]\+\.[[:digit:]]\+~shiboken6${PYTHON_CONFIG_SUFFIX}~g' \
		-e 's~/bin/shiboken6~/bin/shiboken6${PYTHON_CONFIG_SUFFIX}~g' \
		"${ED}/usr/$(get_libdir)"/cmake/Shiboken6/Shiboken6Targets-${CMAKE_BUILD_TYPE,,}.cmake || die

	# Remove the broken "shiboken_tool.py" script. By inspection, this script
	# reduces to a noop. Moreover, this script raises the following exception:
	#     FileNotFoundError: [Errno 2] No such file or directory: '/usr/bin/../shiboken_tool.py': '/usr/bin/../shiboken_tool.py'
	rm "${ED}"/usr/bin/shiboken_tool.py || die
}
