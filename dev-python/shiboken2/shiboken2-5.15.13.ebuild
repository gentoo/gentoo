# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Split the "/usr/bin/shiboken2" binding generator from the
# "/usr/lib64/libshiboken2-*.so" family of shared libraries. The former
# requires everything (including Clang) at runtime; the latter only requires
# Qt and Python at runtime. Note that "pip" separates these two as well. See:
# https://doc.qt.io/qtforpython/shiboken2/faq.html#is-there-any-runtime-dependency-on-the-generated-binding
# Once split, the PySide2 ebuild should be revised to require
# "/usr/bin/shiboken2" at build time and "libshiboken2-*.so" at runtime.
# TODO: Add PyPy once officially supported. See also:
#     https://bugreports.qt.io/browse/PYSIDE-535
PYTHON_COMPAT=( python3_{10..11} )

LLVM_COMPAT=( 15 )

inherit cmake llvm-r1 python-r1 toolchain-funcs

MY_P=pyside-setup-opensource-src-${PV}

DESCRIPTION="Python binding generator for C++ libraries"
HOMEPAGE="https://wiki.qt.io/PySide2"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}/sources/shiboken2"

# The "sources/shiboken2/libshiboken" directory is triple-licensed under the
# GPL v2, v3+, and LGPL v3. All remaining files are licensed under the GPL v3
# with version 1.0 of a Qt-specific exception enabling shiboken2 output to be
# arbitrarily relicensed. (TODO)
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 ) GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+docstrings numpy test vulkan"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Tests fail pretty bad and I'm not fixing them right now
RESTRICT="test"

# Minimal supported version of Qt.
QT_PV="$(ver_cut 1-3)*:5"

# Since Clang is required at both build- and runtime, BDEPEND is omitted here.
RDEPEND="${PYTHON_DEPS}
	=dev-qt/qtcore-${QT_PV}
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
		sys-devel/llvm:${LLVM_SLOT}
	')
	docstrings? (
		>=dev-libs/libxml2-2.6.32
		>=dev-libs/libxslt-1.1.19
		=dev-qt/qtxml-${QT_PV}
		=dev-qt/qtxmlpatterns-${QT_PV}
	)
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	vulkan? ( dev-util/vulkan-headers )
"
DEPEND="${RDEPEND}
	test? ( =dev-qt/qttest-${QT_PV} )
"

DOCS=( AUTHORS )

src_prepare() {
	# TODO: File upstream issue requesting a sane way to disable NumPy support.
	if ! use numpy; then
		sed -i -e '/\bprint(os\.path\.realpath(numpy))/d' \
			libshiboken/CMakeLists.txt || die
	fi

	# Shiboken2 assumes Vulkan headers live under either "$VULKAN_SDK/include"
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

	# Shiboken2 assumes the "/usr/lib/clang/${CLANG_NEWEST_VERSION}/include/"
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
	# PySide2 does *NOT* care whether the end user has done so or not, as
	# PySide2 unconditionally requires Clang in either case. See also:
	#     https://bugs.gentoo.org/619490
	sed -i -e 's~(findClangBuiltInIncludesDir())~(QStringLiteral("'"${EPREFIX}"'/usr/lib/clang/'"${clangver}"'/include"))~' \
		ApiExtractor/clangparser/compilersupport.cpp || die

	cmake_src_prepare
}

src_configure() {
	# Minimal tests for now, 2 failing with the extended version
	# FIXME Subscripted generics cannot be used with class and instance checks
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DDISABLE_DOCSTRINGS=$(usex !docstrings)
	)

	shiboken2_configure() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DUSE_PYTHON_VERSION="${EPYTHON#python}"
			-DFORCE_LIMITED_API=OFF
		)
		# CMakeLists.txt expects LLVM_INSTALL_DIR as an environment variable.
		local -x LLVM_INSTALL_DIR="$(get_llvm_prefix)"
		cmake_src_configure
	}
	python_foreach_impl shiboken2_configure
}

src_compile() {
	python_foreach_impl cmake_src_compile
}

src_test() {
	python_foreach_impl cmake_src_test
}

src_install() {
	shiboken2_install() {
		cmake_src_install
		python_optimize

		# Uniquify the "shiboken2" executable for the current Python target,
		# preserving an unversioned "shiboken2" file arbitrarily associated
		# with the last Python target.
		cp "${ED}"/usr/bin/${PN}{,-${EPYTHON}} || die

		# Uniquify the Shiboken2 pkgconfig file for the current Python target,
		# preserving an unversioned "shiboken2.pc" file arbitrarily associated
		# with the last Python target. See also:
		#     https://github.com/leycec/raiagent/issues/73
		cp "${ED}/usr/$(get_libdir)"/pkgconfig/${PN}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl shiboken2_install

	# CMakeLists.txt installs a "Shiboken2Targets-gentoo.cmake" file forcing
	# downstream consumers (e.g., PySide2) to target one "libshiboken2-*.so"
	# library and one "shiboken2" executable linked to one Python interpreter.
	# See also:
	#     https://bugreports.qt.io/browse/PYSIDE-1053
	#     https://github.com/leycec/raiagent/issues/74
	sed -i \
		-e 's~shiboken2-python[[:digit:]]\+\.[[:digit:]]\+~shiboken2${PYTHON_CONFIG_SUFFIX}~g' \
		-e 's~/bin/shiboken2~/bin/shiboken2${PYTHON_CONFIG_SUFFIX}~g' \
		"${ED}/usr/$(get_libdir)"/cmake/Shiboken2*/Shiboken2Targets-${CMAKE_BUILD_TYPE,,}.cmake || die

	# Remove the broken "shiboken_tool.py" script. By inspection, this script
	# reduces to a noop. Moreover, this script raises the following exception:
	#     FileNotFoundError: [Errno 2] No such file or directory: '/usr/bin/../shiboken_tool.py': '/usr/bin/../shiboken_tool.py'
	rm "${ED}"/usr/bin/shiboken_tool.py || die
}
