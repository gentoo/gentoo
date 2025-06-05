# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTE: We combine here several PyPI packages, we do this because
# pyside can and does break if it is compiled with a different
# toolchain then was used to build shiboken. This bundling ensures
# that we always use the same toolchain for all components.

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
LLVM_COMPAT=( {16..20} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 llvm-r1 multiprocessing qmake-utils virtualx

MY_PN=${PN}-setup-everywhere-src
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://wiki.qt.io/PySide6"

if [[ ${PV} == *.9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI=(
		"https://code.qt.io/${PN}/${PN}-setup.git"
		"https://github.com/qtproject/${PN}-${PN}-setup.git"
	)
	EGIT_BRANCH=dev
	[[ ${PV} == 6.*.9999 ]] && EGIT_BRANCH=${PV%.9999}
else
	SRC_URI="https://download.qt.io/official_releases/QtForPython/${PN}6/PySide6-${PV}-src/${MY_P}.tar.xz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="|| ( GPL-2 GPL-3 LGPL-3 )"
SLOT="6/${PV}"

# If a flag enables multiple Qt modules, they should be ordered
# according to their dependencies, e.g. for 3d, 3DCore must be first.
# Widgets for various modules are handled as a special case later
declare -A QT_MODULES=(
	["3d"]="3DCore 3DRender 3DLogic 3DInput 3DAnimation 3DExtras"
	["bluetooth"]="Bluetooth"
	["charts"]="Charts"
	["+concurrent"]="Concurrent"
	["+core"]="Core"
	["+dbus"]="DBus"
	["designer"]="Designer"
	["+gui"]="Gui"
	["help"]="Help"
	["httpserver"]="HttpServer"
	["location"]="Location"
	["multimedia"]="Multimedia" # plus widgets
	["network-auth"]="NetworkAuth"
	["+network"]="Network"
	["nfc"]="Nfc"
	["+opengl"]="OpenGL" # plus widgets
	["pdfium"]="Pdf" # plus widgets
	["positioning"]="Positioning"
	["+printsupport"]="PrintSupport"
	["qml"]="Qml"
	["quick3d"]="Quick3D"
	["quick"]="Quick" # plus widgets
	["remoteobjects"]="RemoteObjects"
	["scxml"]="Scxml"
	["sensors"]="Sensors"
	["serialbus"]="SerialBus"
	["serialport"]="SerialPort"
	["spatialaudio"]="SpatialAudio"
	["+sql"]="Sql"
	["svg"]="Svg" # plus widgets
	["speech"]="TextToSpeech"
	["+testlib"]="Test"
	["uitools"]="UiTools"
	["webchannel"]="WebChannel"
	["webengine"]="WebEngineCore" # plus widgets and quick
	["websockets"]="WebSockets"
	["webview"]="WebView"
	["+widgets"]="Widgets"
	["+xml"]="Xml"
)

# Manually reextract these requirements on version bumps by running the
# following one-liner from within "${S}":
#     $ grep 'set.*_deps' PySide6/Qt*/CMakeLists.txt
declare -A QT_REQUIREMENTS=(
	["3d"]="gui network opengl"
	["bluetooth"]="core"
	["charts"]="core gui widgets"
	["concurrent"]="core"
	["dbus"]="core"
	["designer"]="widgets"
	["gles2-only"]="gui"
	["gui"]="core"
	["help"]="widgets"
	["httpserver"]="core concurrent network websockets"
	["location"]="core positioning"
	["multimedia"]="core gui network"
	["network-auth"]="network"
	["network"]="core"
	["nfc"]="core"
	["opengl"]="gui"
	["pdfium"]="core gui network"
	["positioning"]="core"
	["printsupport"]="widgets"
	["qml"]="network"
	["quick"]="gui network qml opengl"
	["quick3d"]="gui network qml quick"
	["remoteobjects"]="core network"
	["scxml"]="core"
	["sensors"]="core"
	["serialbus"]="core network serialport"
	["serialport"]="core"
	["spatialaudio"]="core gui network multimedia"
	["speech"]="core multimedia"
	["sql"]="widgets"
	["svg"]="gui"
	["testlib"]="widgets"
	["uitools"]="widgets"
	["webchannel"]="core"
	["webengine"]="core gui network printsupport quick webchannel"
	["websockets"]="network"
	["webview"]="gui quick webengine"
	["widgets"]="gui"
	["xml"]="core"
)

IUSE="${!QT_MODULES[@]} debug doc gles2-only numpy test tools"
RESTRICT="!test? ( test )"

# majority of QtQml tests require QtQuick support
REQUIRED_USE="
	test? (
		qml? ( quick )
	)
"
for requirement in ${!QT_REQUIREMENTS[@]}; do
	REQUIRED_USE+=" ${requirement}? ( ${QT_REQUIREMENTS[${requirement}]} ) "
done

# Minimal supported version of Qt.
QT_PV="$(ver_cut 1-3)*:6"

# WebEngine needs sound support, so enable either pulseaudio or alsa
RDEPEND="
	=dev-qt/qtbase-${QT_PV}[concurrent?,dbus?,gles2-only=,network?,opengl?,sql?,widgets?,xml?]
	3d? ( =dev-qt/qt3d-${QT_PV}[qml?,gles2-only=] )
	bluetooth? ( =dev-qt/qtconnectivity-${QT_PV}[bluetooth] )
	charts? ( =dev-qt/qtcharts-${QT_PV} )
	designer? ( =dev-qt/qttools-${QT_PV}[designer,widgets,gles2-only=] )
	gui? (
		=dev-qt/qtbase-${QT_PV}[gui,jpeg(+)]
		x11-libs/libxkbcommon
	)
	help? ( =dev-qt/qttools-${QT_PV}[assistant,gles2-only=] )
	httpserver? ( =dev-qt/qthttpserver-${QT_PV} )
	location? ( =dev-qt/qtlocation-${QT_PV} )
	multimedia? ( =dev-qt/qtmultimedia-${QT_PV}[widgets(+)?] )
	network? ( =dev-qt/qtbase-${QT_PV}[ssl] )
	network-auth? ( =dev-qt/qtnetworkauth-${QT_PV} )
	nfc? ( =dev-qt/qtconnectivity-${QT_PV}[nfc] )
	numpy? ( >=dev-python/numpy-2.1.3[${PYTHON_USEDEP}] )
	pdfium? ( =dev-qt/qtwebengine-${QT_PV}[pdfium(-),widgets?] )
	positioning? ( =dev-qt/qtpositioning-${QT_PV} )
	printsupport? ( =dev-qt/qtbase-${QT_PV}[gui,widgets] )
	qml? ( =dev-qt/qtdeclarative-${QT_PV}[opengl?,widgets?] )
	quick3d? ( =dev-qt/qtquick3d-${QT_PV}[opengl?] )
	remoteobjects? ( =dev-qt/qtremoteobjects-${QT_PV} )
	scxml? ( =dev-qt/qtscxml-${QT_PV} )
	sensors? ( =dev-qt/qtsensors-${QT_PV}[qml?] )
	speech? ( =dev-qt/qtspeech-${QT_PV} )
	serialbus? ( =dev-qt/qtserialbus-${QT_PV} )
	serialport? ( =dev-qt/qtserialport-${QT_PV} )
	svg? ( =dev-qt/qtsvg-${QT_PV} )
	testlib? ( =dev-qt/qtbase-${QT_PV}[gui] )
	tools? (
		=dev-qt/qtbase-${QT_PV}
		=dev-qt/qtdeclarative-${QT_PV}[qmlls]
		=dev-qt/qttools-${QT_PV}[assistant,designer,linguist]
		dev-python/pkginfo[${PYTHON_USEDEP}]
	)
	uitools? ( =dev-qt/qttools-${QT_PV}[gles2-only=,widgets] )
	webchannel? ( =dev-qt/qtwebchannel-${QT_PV} )
	webengine? ( || (
		=dev-qt/qtwebengine-${QT_PV}[alsa,widgets?]
		=dev-qt/qtwebengine-${QT_PV}[pulseaudio,widgets?]
		)
	)
	websockets? ( =dev-qt/qtwebsockets-${QT_PV} )
	webview? ( =dev-qt/qtwebview-${QT_PV} )
	!dev-python/pyside:0
	!dev-python/shiboken6
	!dev-python/pyside6-tools
"

DEPEND="${RDEPEND}
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/llvm:${LLVM_SLOT}
	')
	dev-util/vulkan-headers
	test? ( =dev-qt/qtbase-${QT_PV}[gui] )
" # testlib is toggled by the gui flag on qtbase

BDEPEND="
	dev-build/cmake
	dev-python/distro[${PYTHON_USEDEP}]
	<dev-python/wheel-0.46.0[${PYTHON_USEDEP}]
	dev-util/patchelf
	doc? (
		>=dev-libs/libxml2-2.6.32
		>=dev-libs/libxslt-1.1.19
		media-gfx/graphviz
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/myst-parser[${PYTHON_USEDEP}]
	)
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
"

PATCHES=(
	# Needs porting to newer wheel and setuptools
	"${FILESDIR}/${PN}-6.8.2-quick-fix-build-wheel.patch"
	"${FILESDIR}/${PN}-6.9.1-fix-tests-cmake4.patch"
)

# Build system duplicates system libraries. TODO: fix
QA_PREBUILT=(
	"/usr/lib/python*/site-packages/PySide6/*"
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Shiboken6 assumes Vulkan headers live under either "$VULKAN_SDK/include"
	# or "$VK_SDK_PATH/include" rather than "${EPREFIX}/usr/include/vulkan".
	sed -i -e "s~\bdetectVulkan(&headerPaths);~headerPaths.append(HeaderPath{QByteArrayLiteral(\"${EPREFIX}/usr/include/vulkan\"), HeaderType::System});~" \
			sources/shiboken6/ApiExtractor/clangparser/compilersupport.cpp || die

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
	sed -e \
		's~(findClangBuiltInIncludesDir())~(QStringLiteral("'"${EPREFIX}"'/usr/lib/clang/'"${LLVM_SLOT}"'/include"))~' \
		-i sources/shiboken6/ApiExtractor/clangparser/compilersupport.cpp || die

	# blacklist.txt works like XFAIL
	cat <<- EOF >> build_history/blacklist.txt || die
	# segfaults with QOpenGLContext::create
	[pysidetest::qapp_like_a_macro_test]
		linux
	# Tries to execute pip install
	[pyside6-deploy::test_pyside6_deploy]
		linux
	[pyside6-android-deploy::test_pyside6_android_deploy]
		linux
	EOF

	if ! use numpy; then
		cat <<- EOF >> build_history/blacklist.txt || die
		# Requires numpy support to pass
		[sample::array_numpy]
			linux
		[sample::nontypetemplate]
			linux
		[QtGui::qpainter_test]
			linux
		EOF
	fi
}

python_configure_all() {
	ENABLED_QT_MODULES=()

	# The order matters, dependencies must come first so process
	# REQUIRED_USE and recursively enable modules
	enable_qt_mod() {
		local flag=${1}
		local modules=${QT_MODULES[${flag}]}
		if [[ -z ${modules} ]]; then
			die "incorrect flag=${flag}, not registered"
		fi
		local dependencies=${QT_REQUIREMENTS[${flag//+}]}
		if [[ -n ${dependencies} ]]; then
			local depflag
			for depflag in ${dependencies}; do
				if use ${depflag}; then
					if [[ -z ${QT_MODULES[${depflag}]} ]]; then
						depflag=+${depflag}
					fi
					enable_qt_mod ${depflag}
				else
					die "${depflag} is required but not enabled"
				fi
			done
		fi
		if [[ "${ENABLED_QT_MODULES[*]}" != *${modules}* ]]; then
			ENABLED_QT_MODULES+=( ${modules} )
		fi
	}
	# Enable specified qt modules
	local flag
	for flag in ${!QT_MODULES[@]}; do
		if use ${flag//+}; then
			enable_qt_mod ${flag}
		fi
	done

	# Special cases
	if use widgets; then
		use multimedia && ENABLED_QT_MODULES+=( MultimediaWidgets )
		use opengl && ENABLED_QT_MODULES+=( OpenGLWidgets )
		use pdfium && ENABLED_QT_MODULES+=( PdfWidgets )
		use quick && ENABLED_QT_MODULES+=( QuickWidgets )
		use svg && ENABLED_QT_MODULES+=( SvgWidgets )
		use webengine && ENABLED_QT_MODULES+=( WebEngineWidgets )
	fi
	if use quick; then
		use webengine && ENABLED_QT_MODULES+=( WebEngineQuick )
		use testlib && ENABLED_QT_MODULES+=( QuickTest )
	fi

	# Arguments listed in options.py
	MAIN_DISTUTILS_ARGS=(
		--cmake="${EPREFIX}/usr/bin/cmake"
		--ignore-git
		--limited-api=no
		--module-subset="$(printf '%s,' "${ENABLED_QT_MODULES[@]}")"
		--no-strip
		--no-size-optimization
		--openssl="${EPREFIX}/usr/bin/openssl"
		--qt=$(ver_cut 1-3)
		--qtpaths=$(qt6_get_bindir)/qtpaths
		--verbose-build
		--parallel=$(makeopts_jobs)
		$(usex debug "--debug" "--relwithdebinfo")
		$(usex doc "--build-docs" "--skip-docs")
		$(usex numpy "--enable-numpy-support" "--disable-numpy-support")
		$(usex test "--build-tests --use-xvfb" "")
		$(usex tools "" "--no-qt-tools")
	)
}

python_compile() {
	DISTUTILS_ARGS=(
		"${MAIN_DISTUTILS_ARGS[@]}"
		--build-type=shiboken6
	)
	distutils-r1_python_compile

	# The build system uses its own build dir, find the name of this dir.
	local pyside_build_dir=$(find "${BUILD_DIR}/build$((${#DISTUTILS_WHEELS[@]}-1))" -maxdepth 1 -type d -name 'qfp*-py*-qt*-*' -printf "%f\n")
	export pyside_build_id=${pyside_build_dir#qfp$(usev debug d)-py${EPYTHON#python}-qt$(ver_cut 1-3)-}

	DISTUTILS_ARGS=(
		"${MAIN_DISTUTILS_ARGS[@]}"
		--reuse-build
		--shiboken-target-path="${BUILD_DIR}/build$((${#DISTUTILS_WHEELS[@]}-1))/${pyside_build_dir}/install"
		--build-type=shiboken6-generator
	)
	distutils-r1_python_compile
	# If no pyside modules enabled, build just shiboken
	if [[ ${#ENABLED_QT_MODULES[@]} -gt 0 ]]; then
		DISTUTILS_ARGS=(
			"${MAIN_DISTUTILS_ARGS[@]}"
			--reuse-build
			--shiboken-target-path="${BUILD_DIR}/build$((${#DISTUTILS_WHEELS[@]}-1))/${pyside_build_dir}/install"
			--build-type=pyside6
		)
		distutils-r1_python_compile
	fi

	# Link libraries to the usual location for backwards compatibility
	pushd "${BUILD_DIR}/install/$(python_get_sitedir)" >/dev/null ||
		die
	mkdir -p "${BUILD_DIR}/install/usr/$(get_libdir)" || die
	local lib
	for lib in */*.cpython-*.so
	do
		local base=${lib##*/}
		ln -s "${base}" "${lib%/*}/${base%%.*}-${EPYTHON}.so" ||
			die
	done
	for lib in */*.cpython-*.so.$(ver_cut 1-2)
	do
		local base=${lib##*/}
		ln -s "${base}" "${lib%/*}/${base%%.*}-${EPYTHON}.so.$(ver_cut 1-2)" ||
			die
	done
	for lib in */*.so*; do
		ln -s "../../$(python_get_sitedir)/${lib}" \
			"${BUILD_DIR}/install/usr/$(get_libdir)/${lib#*/}" || die
	done
	popd >/dev/null || die

	# Symlinks for compatibility with pypi wheels
	local dir
	if [[ -d ${BUILD_DIR}/install/$(python_get_sitedir)/PySide6 ]]
	then
		pushd "${BUILD_DIR}/install/$(python_get_sitedir)/PySide6" \
			>/dev/null || die
		mkdir -p "${BUILD_DIR}/install/usr/share/PySide6" || die
		for dir in doc glue typesystems; do
			ln -s "../../../$(python_get_sitedir)/PySide6/${dir}" \
				"${BUILD_DIR}/install/usr/share/PySide6/${dir}" ||
					die
		done
		popd >/dev/null || die
	fi
	mkdir -p "${BUILD_DIR}/install/usr/include"
	for dir in PySide6 shiboken6_generator; do
		if [[ -d ${BUILD_DIR}/install/$(python_get_sitedir)/${dir}/include ]]
		then
			ln -s "../../$(python_get_sitedir)/${dir}/include" \
				"${BUILD_DIR}/install/usr/include/${dir//_generator}" ||
					die
		fi
	done

	# Install misc files from inner install dir
	find "${BUILD_DIR}"/build*/${pyside_build_dir}/install -type f \
		-name libPySidePlugin.so -exec \
		mkdir -p "${BUILD_DIR}/install/$(qt6_get_plugindir)/designer/" \; \
		-exec \
		cp "{}" "${BUILD_DIR}/install/$(qt6_get_plugindir)/designer/" \; \
			|| die

	for dir in cmake pkgconfig; do
		find "${BUILD_DIR}"/build*/${pyside_build_dir}/install -type d -name ${dir} \
			-exec cp -r "{}" "${BUILD_DIR}/install/usr/lib/" \; \
				|| die
	done

	# Uniquify the pkgconfigs file for the current Python target,
	# preserving an unversioned "shiboken6.pc" file arbitrarily
	# associated with the last Python target.
	if [[ -f ${BUILD_DIR}/install/usr/lib/pkgconfig/shiboken6.pc ]]
	then
		sed -e 's~prefix=.*~prefix=/usr~g' \
			-e 's~exec_prefix=.*~exec_prefix=${prefix}~g' \
			-e "s~libdir=.*~libdir=$(python_get_sitedir)/shiboken6~g" \
			-e "s~includedir=.*~includedir=$(python_get_sitedir)/shiboken6_generator/include~g" \
			-i "${BUILD_DIR}/install/usr/lib/pkgconfig/shiboken6.pc" || die
		cp "${BUILD_DIR}/install/usr/lib/pkgconfig/"shiboken6{,-${EPYTHON}}.pc || die
	fi
	if [[ -f ${BUILD_DIR}/install/usr/lib/pkgconfig/pyside6.pc ]]
	then
		sed -e 's~^Requires: shiboken6$~&-'${EPYTHON}'~' \
			-e 's~prefix=.*~prefix=/usr~g' \
			-e 's~exec_prefix=.*~exec_prefix=${prefix}~g' \
			-e "s~libdir=.*~libdir=$(python_get_sitedir)/PySide6~g" \
			-e "s~includedir=.*~includedir=$(python_get_sitedir)/PySide6/include~g" \
			-e "s~typesystemdir=.*~typesystemdir=$(python_get_sitedir)/PySide6/typesystems~g" \
			-e "s~gluedir=.*~gluedir=$(python_get_sitedir)/PySide6/glue~g" \
			-e "s~pythonpath=.*~pythonpath=$(python_get_sitedir)~g" \
			-i "${BUILD_DIR}/install/usr/lib/pkgconfig/pyside6.pc" || die
		cp "${BUILD_DIR}/install/usr/lib/pkgconfig/"pyside6{,-${EPYTHON}}.pc || die
	fi

	sed \
		-e "s~/lib/libshiboken6\.cpython~/$(get_libdir)/libshiboken6\.cpython~g" \
		-e "s~/lib/libpyside6\.cpython~/$(get_libdir)/libpyside6\.cpython~g" \
		-e "s~/lib/libpyside6qml\.cpython~/$(get_libdir)/libpyside6qml\.cpython~g" \
		-e "s~libshiboken6\.cpython.*\.so\.$(ver_cut 1-3)~libshiboken6\${PYTHON_CONFIG_SUFFIX}\.so\.$(ver_cut 1-2)~g" \
		-e "s~libpyside6\.cpython.*\.so\.$(ver_cut 1-3)~libpyside6\${PYTHON_CONFIG_SUFFIX}\.so\.$(ver_cut 1-2)~g" \
		-e "s~libpyside6qml\.cpython.*\.so\.$(ver_cut 1-3)~libpyside6qml\${PYTHON_CONFIG_SUFFIX}\.so\.$(ver_cut 1-2)~g" \
		-e "s~libshiboken6\.cpython.*\.so\.$(ver_cut 1-2)~libshiboken6\${PYTHON_CONFIG_SUFFIX}\.so\.$(ver_cut 1-2)~g" \
		-e "s~libpyside6\.cpython.*\.so\.$(ver_cut 1-2)~libpyside6\${PYTHON_CONFIG_SUFFIX}\.so\.$(ver_cut 1-2)~g" \
		-e "s~libpyside6qml\.cpython.*\.so\.$(ver_cut 1-2)~libpyside6qml\${PYTHON_CONFIG_SUFFIX}\.so\.$(ver_cut 1-2)~g" \
		-i 	"${BUILD_DIR}/install/usr/lib/cmake/"*/*.cmake || die
	local file
	for file in "${BUILD_DIR}/install/usr/lib/cmake/"*/*.cpython-*.cmake
	do
		local base=${file##*/}
		ln -s "${base}" "${file%/*}/${base%%.*}-${EPYTHON}.cmake" ||
			die
	done
}

python_test() {
	# Otherwise it picks the last built directory breaking assumption for multi target builds
	mkdir -p build_history/9999-99-99_999999/ || die
	local pyside_build_dir=qfp$(usev debug d)-py${EPYTHON#python}-qt$(ver_cut 1-3)-${pyside_build_id}
	echo "$(ls -d "${BUILD_DIR}"/build*/${pyside_build_dir}/build | sort -V | tail -n 1)" > build_history/9999-99-99_999999/build_dir.txt || die
	echo "${pyside_build_dir}" >> build_history/9999-99-99_999999/build_dir.txt || die

	virtx ${EPYTHON} testrunner.py test --projects=shiboken6 $(usev core '--projects=pyside6')  ||
		die "Tests failed with ${EPYTHON}"
}

pkg_preinst() {
	# Avoid symlinks being blocked by directories
	rm -rf "${EROOT}/usr/include/"{PySide6,shiboken6} || die
	rm -rf "${EROOT}/usr/share/PySide6" || die
}
