# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: qt5-build.eclass
# @MAINTAINER:
# qt@gentoo.org
# @AUTHOR:
# Davide Pesavento <pesa@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Eclass for Qt5 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt5.

if [[ ${CATEGORY} != dev-qt ]]; then
	die "${ECLASS} is only to be used for building Qt 5"
fi

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @ECLASS_VARIABLE: QT5_BUILD_TYPE
# @DESCRIPTION:
# Default value is "release".
# If PV matches "*9999*", this is automatically set to "live".
QT5_BUILD_TYPE=release
if [[ ${PV} == *9999* ]]; then
	QT5_BUILD_TYPE=live
fi
readonly QT5_BUILD_TYPE

# @ECLASS_VARIABLE: QT5_KDEPATCHSET_REV
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Downstream generated patchset revision pulled from KDE's Qt5PatchCollection,
# with the patchset having been generated in the following way from upstream's
# qt module git repository:
# @CODE
# git format-patch v${PV}-lts-lgpl..origin/gentoo-kde/${PV} \
#	-o ${QT5_MODULE}-${PV}-gentoo-kde-${QT5_KDEPATCHSET_REV}
# @CODE
# Used for SRC_URI and applied in src_prepare.
# Must be set before inheriting the eclass.

# @ECLASS_VARIABLE: QT5_MODULE
# @PRE_INHERIT
# @DESCRIPTION:
# The upstream name of the module this package belongs to. Used for
# SRC_URI and EGIT_REPO_URI. Must be set before inheriting the eclass.
: ${QT5_MODULE:=${PN}}

# @ECLASS_VARIABLE: QT5_PV
# @DESCRIPTION:
# 3-component version for use in dependency declarations on other dev-qt/ pkgs.
QT5_PV=$(ver_cut 1-3)
readonly QT5_PV

# @ECLASS_VARIABLE: _QT5_P
# @INTERNAL
# @DESCRIPTION:
# The upstream package name of the module this package belongs to.
# Used for SRC_URI and S.

# @ECLASS_VARIABLE: QT5_TARGET_SUBDIRS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array variable containing the source directories that should be built.
# All paths must be relative to ${S}.

# @ECLASS_VARIABLE: QT5_GENTOO_CONFIG
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of <useflag:feature:macro> triplets that are evaluated in src_install
# to generate the per-package list of enabled QT_CONFIG features and macro
# definitions, which are then merged together with all other Qt5 packages
# installed on the system to obtain the global qconfig.{h,pri} files.

# @ECLASS_VARIABLE: QT5_GENTOO_PRIVATE_CONFIG
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of <useflag:feature> pairs that are evaluated in src_install
# to generate the per-package list of enabled QT.global_private features,
# which are then merged together with all other Qt5 packages installed on the
# system to obtain the global qmodule.pri file.

# @ECLASS_VARIABLE: VIRTUALX_REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# For proper description see virtualx.eclass man page.
# Here we redefine default value to be manual, if your package needs virtualx
# for tests you should proceed with setting VIRTUALX_REQUIRED=test.
: ${VIRTUALX_REQUIRED:=manual}

inherit estack flag-o-matic toolchain-funcs virtualx

if [[ ${PN} != qtwebengine ]]; then
	case ${PV} in
		*9999 )
			# kde/5.15 branch on invent.kde.org
			inherit kde.org
			;;
		5.15.2* )
			if [[ -n ${KDE_ORG_COMMIT} ]]; then
				# KDE Qt5PatchCollection snapshot based on Qt 5.15.2
				inherit kde.org
			else
				# official stable release
				_QT5_P=${QT5_MODULE}-everywhere-src-${PV}
				HOMEPAGE="https://www.qt.io/"
				SRC_URI="https://download.qt.io/official_releases/qt/${PV%.*}/${PV}/submodules/${_QT5_P}.tar.xz"
				S=${WORKDIR}/${_QT5_P}
			fi
			;;
		5.15.[3-9]* )
			# official stable release
			_QT5_P=${QT5_MODULE}-everywhere-opensource-src-${PV}
			HOMEPAGE="https://www.qt.io/"
			SRC_URI="https://download.qt.io/official_releases/qt/${PV%.*}/${PV}/submodules/${_QT5_P}.tar.xz"
			# KDE Qt5PatchCollection on top of tag v${PV}-lts-lgpl
			if [[ -n ${QT5_KDEPATCHSET_REV} ]]; then
				HOMEPAGE+=" https://invent.kde.org/qt/qt/${QT5_MODULE} https://community.kde.org/Qt5PatchCollection"
				SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${QT5_MODULE}-${PV}-gentoo-kde-${QT5_KDEPATCHSET_REV}.tar.xz"
			fi
			S="${WORKDIR}"/${_QT5_P/opensource-}
			;;
	esac
fi

# @ECLASS_VARIABLE: QT5_BUILD_DIR
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Build directory for out-of-source builds.
: ${QT5_BUILD_DIR:=${S}_build}

LICENSE="|| ( GPL-2 GPL-3 LGPL-3 ) FDL-1.3"

case ${PV} in
	5.15.2*)
		SLOT=5/$(ver_cut 1-2)
		;;
	*)
		case ${PN} in
			assistant|linguist|qdbus|qdbusviewer|pixeltool)
				SLOT=0 ;;
			linguist-tools|qdoc|qtdiag|qtgraphicaleffects|qtimageformats| \
			qtpaths|qtplugininfo|qtquickcontrols|qtquicktimeline| \
			qttranslations|qtwaylandscanner|qtxmlpatterns)
				SLOT=5 ;;
			*)
				SLOT=5/$(ver_cut 1-2) ;;
		esac
		;;
esac

IUSE="debug test"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	RESTRICT="test" # bug 457182
else
	RESTRICT="!test? ( test )"
fi

BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
"
if [[ ${PN} != qttest ]]; then
	DEPEND+=" test? ( =dev-qt/qttest-${QT5_PV}* )"
fi

######  Phase functions  ######

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install src_test pkg_postinst pkg_postrm

# @FUNCTION: qt5-build_src_prepare
# @DESCRIPTION:
# Prepares the environment and patches the sources if necessary.
qt5-build_src_prepare() {
	qt5_prepare_env

	if [[ ${QT5_BUILD_TYPE} == live ]] || [[ -n ${KDE_ORG_COMMIT} ]]; then
		if [[ -n ${KDE_ORG_COMMIT} ]]; then
			einfo "Preparing KDE Qt5PatchCollection snapshot at ${KDE_ORG_COMMIT}"
			mkdir -p .git || die # need to fake a git repository for configure
		fi
		# Ensure our ${QT5_PV} is not contradicted by any upstream (Qt) commit
		# bumping version in 5.15 branch after release (probably can be dropped
		# after 5.15.2_p* are gone)
		sed -e "/^MODULE_VERSION/s/5\.15\.[3456789]/${QT5_PV}/" -i .qmake.conf || die
	fi

	if [[ ${QT5_MODULE} == qtbase ]]; then
		qt5_symlink_tools_to_build_dir

		# Avoid unnecessary qmake recompilations
		sed -i -e "/Creating qmake/i if [ '!' -e \"\$outpath/bin/qmake\" ]; then" \
			-e '/echo "Done."/a fi' configure || die "sed failed (skip qmake bootstrap)"

		# Respect CC, CXX, *FLAGS, MAKEOPTS and EXTRA_EMAKE when bootstrapping qmake
		sed -i -e "/outpath\/qmake\".*\"\$MAKE\")/ s|)| \
			${MAKEOPTS} ${EXTRA_EMAKE} 'CC=$(tc-getCC)' 'CXX=$(tc-getCXX)' \
			'QMAKE_CFLAGS=${CFLAGS}' 'QMAKE_CXXFLAGS=${CXXFLAGS}' 'QMAKE_LFLAGS=${LDFLAGS}'&|" \
			-e 's/\(setBootstrapVariable\s\+\|EXTRA_C\(XX\)\?FLAGS=.*\)QMAKE_C\(XX\)\?FLAGS_\(DEBUG\|RELEASE\).*/:/' \
			configure || die "sed failed (respect env for qmake build)"
		sed -i -e '/^CPPFLAGS\s*=/ s/-g //' \
			qmake/Makefile.unix || die "sed failed (CPPFLAGS for qmake build)"

		# Respect CXX in bsymbolic_functions, fvisibility, precomp, and a few other tests
		sed -i -e "/^QMAKE_CONF_COMPILER=/ s:=.*:=\"$(tc-getCXX)\":" \
			configure || die "sed failed (QMAKE_CONF_COMPILER)"

		# Respect build variables in configure tests (bug #639494)
		sed -i -e "s|\"\$outpath/bin/qmake\" \"\$relpathMangled\" -- \"\$@\"|& $(qt5_qmake_args) |" configure || die
	fi

	[[ -n ${QT5_KDEPATCHSET_REV} ]] && eapply "${WORKDIR}/${QT5_MODULE}-${PV}-gentoo-kde-${QT5_KDEPATCHSET_REV}"

	default
}

# @FUNCTION: qt5-build_src_configure
# @DESCRIPTION:
# Runs qmake in the target directories. For packages
# in qtbase, ./configure is also run before qmake.
qt5-build_src_configure() {
	if [[ ${QT5_MODULE} == qtbase ]]; then
		qt5_base_configure
	fi
	if [[ ${QT5_MODULE} == qttools ]]; then
		qt5_tools_configure
	fi

	qt5_foreach_target_subdir qt5_qmake
}

# @FUNCTION: qt5-build_src_compile
# @DESCRIPTION:
# Runs emake in the target directories.
qt5-build_src_compile() {
	qt5_foreach_target_subdir emake
}

# @FUNCTION: qt5-build_src_test
# @DESCRIPTION:
# Runs tests in the target directories.
qt5-build_src_test() {
	# disable broken cmake tests (bug 474004)
	local myqmakeargs=("${myqmakeargs[@]}" -after SUBDIRS-=cmake SUBDIRS-=installed_cmake)

	qt5_foreach_target_subdir qt5_qmake
	qt5_foreach_target_subdir emake

	# create a custom testrunner script that correctly sets
	# LD_LIBRARY_PATH before executing the given test
	local testrunner=${QT5_BUILD_DIR}/gentoo-testrunner
	cat > "${testrunner}" <<-_EOF_ || die
	#!/bin/sh
	export LD_LIBRARY_PATH="${QT5_BUILD_DIR}/lib:${QT5_LIBDIR}"
	"\$@"
	_EOF_
	chmod +x "${testrunner}"

	set -- qt5_foreach_target_subdir emake TESTRUNNER="'${testrunner}'" check
	if [[ ${VIRTUALX_REQUIRED} == test ]]; then
		virtx "$@"
	else
		"$@"
	fi
}

# @FUNCTION: qt5-build_src_install
# @DESCRIPTION:
# Runs emake install in the target directories.
qt5-build_src_install() {
	qt5_foreach_target_subdir emake INSTALL_ROOT="${D}" install

	if [[ ${PN} == qtcore ]]; then
		pushd "${QT5_BUILD_DIR}" >/dev/null || die

		set -- emake INSTALL_ROOT="${D}" \
			sub-qmake-qmake-aux-pro-install_subtargets \
			install_{syncqt,mkspecs}

		einfo "Running $*"
		"$@"

		popd >/dev/null || die

		# install an empty Gentoo/gentoo-qconfig.h in ${D}
		# so that it's placed under package manager control
		> "${T}"/gentoo-qconfig.h
		(
			insinto "${QT5_HEADERDIR#${EPREFIX}}"/Gentoo
			doins "${T}"/gentoo-qconfig.h
		)

		# include gentoo-qconfig.h at the beginning of QtCore/qconfig.h
		sed -i -e '1i #include <Gentoo/gentoo-qconfig.h>\n' \
			"${D}${QT5_HEADERDIR}"/QtCore/qconfig.h \
			|| die "sed failed (qconfig.h)"

		if ver_test -lt 5.15.2-r10; then
			# install qtchooser configuration file
			cat > "${T}/qt5-${CHOST}.conf" <<-_EOF_ || die
				${QT5_BINDIR}
				${QT5_LIBDIR}
			_EOF_

			(
				insinto /etc/xdg/qtchooser
				doins "${T}/qt5-${CHOST}.conf"
			)

			# convenience symlinks
			dosym qt5-"${CHOST}".conf /etc/xdg/qtchooser/5.conf
			dosym qt5-"${CHOST}".conf /etc/xdg/qtchooser/qt5.conf
			dosym qt5.conf /etc/xdg/qtchooser/default.conf
		fi
	fi

	qt5_install_module_config

	# prune libtool files
	find "${D}" -name '*.la' -type f -delete || die
}

# @FUNCTION: qt5-build_pkg_postinst
# @DESCRIPTION:
# Regenerate configuration after installation or upgrade/downgrade.
qt5-build_pkg_postinst() {
	qt5_regenerate_global_configs
}

# @FUNCTION: qt5-build_pkg_postrm
# @DESCRIPTION:
# Regenerate configuration when a module is completely removed.
qt5-build_pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${PN} != qtcore ]]; then
		qt5_regenerate_global_configs
	fi
}


######  Public helpers  ######

# @FUNCTION: qt5_symlink_binary_to_path
# @USAGE: <target binary name> [suffix]
# @DESCRIPTION:
# Symlink a given binary from QT5_BINDIR to QT5_PREFIX/bin, with optional suffix
qt5_symlink_binary_to_path() {
	[[ $# -ge 1 ]] || die "${FUNCNAME}() requires at least one argument"

	dosym -r "${QT5_BINDIR}"/${1} /usr/bin/${1}${2}
}

# @FUNCTION: qt_use
# @USAGE: <flag> [feature] [enableval]
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
#
# Outputs "-${enableval}-${feature}" if <flag> is enabled, "-no-${feature}"
# otherwise. If [feature] is not specified, <flag> is used in its place.
# If [enableval] is not specified, the "-${enableval}" prefix is omitted.
qt_use() {
	[[ $# -ge 1 ]] || die "${FUNCNAME}() requires at least one argument"

	usex "$1" "${3:+-$3}-${2:-$1}" "-no-${2:-$1}"
}

# @FUNCTION: qt_use_compile_test
# @USAGE: <flag> [config]
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
# [config] is the argument of qtCompileTest, defaults to <flag>.
#
# This function is useful to disable optional dependencies that are checked
# at qmake-time using the qtCompileTest() function. If <flag> is disabled,
# the compile test is skipped and the dependency is assumed to be unavailable,
# i.e. the corresponding feature will be disabled. Note that all invocations
# of this function must happen before calling qt5-build_src_configure.
qt_use_compile_test() {
	[[ $# -ge 1 ]] || die "${FUNCNAME}() requires at least one argument"

	if ! use "$1"; then
		mkdir -p "${QT5_BUILD_DIR}" || die
		echo "CONFIG += done_config_${2:-$1}" >> "${QT5_BUILD_DIR}"/.qmake.cache || die
	fi
}

# @FUNCTION: qt_use_disable_config
# @USAGE: <flag> <config> <files...>
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
# <config> is the (lowercase) name of a Qt5 config entry.
# <files...> is a list of one or more qmake project files.
#
# This function patches <files> to treat <config> as disabled
# when <flag> is disabled, otherwise it does nothing.
# This can be useful to avoid an automagic dependency when the config entry
# is enabled on the system but the corresponding USE flag is disabled.
qt_use_disable_config() {
	[[ $# -ge 3 ]] || die "${FUNCNAME}() requires at least three arguments"

	local flag=$1
	local config=$2
	shift 2

	if ! use "${flag}"; then
		echo "$@" | xargs sed -i -e "s/qtConfig(${config})/false/g" || die
	fi
}

# @FUNCTION: qt_use_disable_mod
# @USAGE: <flag> <module> <files...>
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
# <module> is the (lowercase) name of a Qt5 module.
# <files...> is a list of one or more qmake project files.
#
# This function patches <files> to treat <module> as not installed
# when <flag> is disabled, otherwise it does nothing.
# This can be useful to avoid an automagic dependency when the module
# is present on the system but the corresponding USE flag is disabled.
qt_use_disable_mod() {
	[[ $# -ge 3 ]] || die "${FUNCNAME}() requires at least three arguments"

	local flag=$1
	local module=$2
	shift 2

	if ! use "${flag}"; then
		echo "$@" | xargs sed -i -e "s/qtHaveModule(${module})/false/g" || die
	fi
}


######  Internal functions  ######

# @FUNCTION: qt5_prepare_env
# @INTERNAL
# @DESCRIPTION:
# Prepares the environment for building Qt.
qt5_prepare_env() {
	# setup installation directories
	# note: keep paths in sync with qmake-utils.eclass
	QT5_PREFIX=${EPREFIX}/usr
	QT5_HEADERDIR=${QT5_PREFIX}/include/qt5
	QT5_LIBDIR=${QT5_PREFIX}/$(get_libdir)
	QT5_ARCHDATADIR=${QT5_PREFIX}/$(get_libdir)/qt5
	QT5_BINDIR=${QT5_ARCHDATADIR}/bin
	QT5_PLUGINDIR=${QT5_ARCHDATADIR}/plugins
	QT5_LIBEXECDIR=${QT5_ARCHDATADIR}/libexec
	QT5_IMPORTDIR=${QT5_ARCHDATADIR}/imports
	QT5_QMLDIR=${QT5_ARCHDATADIR}/qml
	QT5_DATADIR=${QT5_PREFIX}/share/qt5
	QT5_DOCDIR=${QT5_PREFIX}/share/qt5-doc
	QT5_TRANSLATIONDIR=${QT5_DATADIR}/translations
	QT5_EXAMPLESDIR=${QT5_DATADIR}/examples
	QT5_TESTSDIR=${QT5_DATADIR}/tests
	QT5_SYSCONFDIR=${EPREFIX}/etc/xdg
	readonly QT5_PREFIX QT5_HEADERDIR QT5_LIBDIR QT5_ARCHDATADIR \
		QT5_BINDIR QT5_PLUGINDIR QT5_LIBEXECDIR QT5_IMPORTDIR \
		QT5_QMLDIR QT5_DATADIR QT5_DOCDIR QT5_TRANSLATIONDIR \
		QT5_EXAMPLESDIR QT5_TESTSDIR QT5_SYSCONFDIR

	if [[ ${QT5_MODULE} == qtbase ]]; then
		# see mkspecs/features/qt_config.prf
		export QMAKEMODULES="${QT5_BUILD_DIR}/mkspecs/modules:${S}/mkspecs/modules:${QT5_ARCHDATADIR}/mkspecs/modules"
	fi
}

# @FUNCTION: qt5_foreach_target_subdir
# @INTERNAL
# @DESCRIPTION:
# Executes the command given as argument from inside each directory
# listed in QT5_TARGET_SUBDIRS. Handles autotests subdirs automatically.
qt5_foreach_target_subdir() {
	[[ -z ${QT5_TARGET_SUBDIRS[@]} ]] && QT5_TARGET_SUBDIRS=("")

	local subdir=
	for subdir in "${QT5_TARGET_SUBDIRS[@]}"; do
		if [[ ${EBUILD_PHASE} == test ]]; then
			subdir=tests/auto${subdir#src}
			[[ -d ${S}/${subdir} ]] || continue
		fi

		local msg="Running $* ${subdir:+in ${subdir}}"
		einfo "${msg}"

		mkdir -p "${QT5_BUILD_DIR}/${subdir}" || die -n || return $?
		pushd "${QT5_BUILD_DIR}/${subdir}" >/dev/null || die -n || return $?

		"$@" || die -n "${msg} failed" || return $?

		popd >/dev/null || die -n || return $?
	done
}

# @FUNCTION: qt5_symlink_tools_to_build_dir
# @INTERNAL
# @DESCRIPTION:
# Symlinks qmake and a few other tools to QT5_BUILD_DIR,
# so that they can be used when building other modules.
qt5_symlink_tools_to_build_dir() {
	local tool= tools=()
	if [[ ${PN} != qtcore ]]; then
		tools+=(qmake moc rcc qlalr)
		[[ ${PN} != qtdbus ]] && tools+=(qdbuscpp2xml qdbusxml2cpp)
		[[ ${PN} != qtwidgets ]] && tools+=(uic)
	fi

	mkdir -p "${QT5_BUILD_DIR}"/bin || die
	pushd "${QT5_BUILD_DIR}"/bin >/dev/null || die

	for tool in "${tools[@]}"; do
		[[ -e ${QT5_BINDIR}/${tool} ]] || continue
		ln -s "${QT5_BINDIR}/${tool}" . || die "failed to symlink ${tool}"
	done

	popd >/dev/null || die
}

# @FUNCTION: qt5_base_configure
# @INTERNAL
# @DESCRIPTION:
# Runs ./configure for modules belonging to qtbase.
qt5_base_configure() {
	# setup toolchain variables used by configure
	tc-export AR CC CXX OBJDUMP RANLIB STRIP
	export LD="$(tc-getCXX)"

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	# configure arguments
	local conf=(
		# installation paths
		-prefix "${QT5_PREFIX}"
		-bindir "${QT5_BINDIR}"
		-headerdir "${QT5_HEADERDIR}"
		-libdir "${QT5_LIBDIR}"
		-archdatadir "${QT5_ARCHDATADIR}"
		-plugindir "${QT5_PLUGINDIR}"
		-libexecdir "${QT5_LIBEXECDIR}"
		-importdir "${QT5_IMPORTDIR}"
		-qmldir "${QT5_QMLDIR}"
		-datadir "${QT5_DATADIR}"
		-docdir "${QT5_DOCDIR}"
		-translationdir "${QT5_TRANSLATIONDIR}"
		-sysconfdir "${QT5_SYSCONFDIR}"
		-examplesdir "${QT5_EXAMPLESDIR}"
		-testsdir "${QT5_TESTSDIR}"

		# force appropriate compiler
		$(if use kernel_linux; then
			if tc-is-gcc; then
				echo -platform linux-g++
			elif tc-is-clang; then
				echo -platform linux-clang
			fi
		fi)

		# configure in release mode by default,
		# override via the CONFIG qmake variable
		-release
		-no-separate-debug-info

		# no need to forcefully build host tools in optimized mode,
		# just follow the overall debug/release build type
		-no-optimized-tools

		# licensing stuff
		-opensource -confirm-license

		# autodetect the highest supported version of the C++ standard
		#-c++std <c++11|c++14|c++1z>

		# build shared libraries
		-shared

		# disabling accessibility is not recommended by upstream, as
		# it will break QStyle and may break other internal parts of Qt
		-accessibility

		# disable all SQL drivers by default, override in qtsql
		-no-sql-db2 -no-sql-ibase -no-sql-mysql -no-sql-oci -no-sql-odbc
		-no-sql-psql -no-sql-sqlite -no-sql-sqlite2 -no-sql-tds

		# MIPS DSP instruction set extensions
		$(is-flagq -mno-dsp   && echo -no-mips_dsp)
		$(is-flagq -mno-dspr2 && echo -no-mips_dspr2)

		# use pkg-config to detect include and library paths
		-pkg-config

		# prefer system libraries (only common hard deps here)
		-system-zlib
		-system-pcre
		-system-doubleconversion

		# disable everything to prevent automagic deps (part 1)
		-no-mtdev
		-no-journald -no-syslog
		-no-libpng -no-libjpeg
		-no-freetype -no-harfbuzz
		-no-openssl -no-libproxy
		-no-feature-gssapi
		-no-xcb-xlib

		# bug 672340
		-no-xkbcommon
		-no-bundled-xcb-xinput

		# cannot use -no-gif because there is no way to override it later
		#-no-gif

		# always enable glib event loop support
		-glib

		# disable everything to prevent automagic deps (part 2)
		-no-gtk

		# exclude examples and tests from default build
		-nomake examples
		-nomake tests
		-no-compile-examples

		# disable rpath on non-prefix (bugs 380415 and 417169)
		$(usex prefix '' -no-rpath)

		# print verbose information about each configure test
		-verbose

		# disable everything to prevent automagic deps (part 3)
		-no-cups -no-evdev -no-tslib -no-icu -no-fontconfig -no-dbus

		# let portage handle stripping
		-no-strip

		# precompiled headers can cause problems on hardened, so turn them off
		-no-pch

		# link-time code generation is not something we want to enable by default
		-no-ltcg

		# reduced relocations cause major breakage on at least arm and ppc, so
		# don't specify anything and let the configure figure out if they are
		# supported; see also https://bugreports.qt.io/browse/QTBUG-36129
		#-reduce-relocations

		# use the system linker (gold will be selected automagically otherwise)
		$(tc-ld-is-gold && echo -use-gold-linker || echo -no-use-gold-linker)

		# disable all platform plugins by default, override in qtgui
		-no-xcb -no-eglfs -no-kms -no-gbm -no-directfb -no-linuxfb

		# always enable session management support: it doesn't need extra deps
		# at configure time and turning it off is dangerous, see bug 518262
		-sm

		# typedef qreal to double (warning: changing this flag breaks the ABI)
		-qreal double

		# disable OpenGL and EGL support by default, override in qtgui,
		# qtopengl, qtprintsupport and qtwidgets
		-no-opengl -no-egl

		# disable libinput-based generic plugin by default, override in qtgui
		-no-libinput

		# respect system proxies by default: it's the most natural
		# setting, and it'll become the new upstream default in 5.8
		-system-proxies

		# do not build with -Werror
		-no-warnings-are-errors

		# enable in respective modules to avoid poisoning QT.global_private.enabled_features
		-no-gui -no-widgets

		# QTBUG-76521, default will change to zstd in Qt6
		-no-zstd

		# module-specific options
		"${myconf[@]}"
	)

	pushd "${QT5_BUILD_DIR}" >/dev/null || die

	einfo "Configuring with: ${conf[@]}"
	"${S}"/configure "${conf[@]}" || die "configure failed"

	# a forwarding header is no longer created since 5.8, causing the system
	# config to always be used. bug 599636
	# ${S}/include does not exist in live sources or kde.org snapshots
	local basedir="${S}/"
	if [[ ${QT5_BUILD_TYPE} == live ]] || [[ -n ${KDE_ORG_COMMIT} ]]; then
		basedir=""
	fi
	cp src/corelib/global/qconfig.h "${basedir}"include/QtCore/ || die

	popd >/dev/null || die

}

# @FUNCTION: qt5_tools_configure
# @INTERNAL
# @DESCRIPTION:
# Most of qttools require files that are only generated when qmake is
# run in the root directory. Related bugs: 676948, 716514.
# Runs qt5_qmake in root directory to create qttools-config.pri and copy to
# ${QT5_BUILD_DIR}, disabling modules other than ${PN} belonging to qttools.
qt5_tools_configure() {
	# configure arguments
	local qmakeargs=(
		--
		# not packaged in Gentoo
		-no-feature-distancefieldgenerator
		-no-feature-kmap2qmap
		-no-feature-macdeployqt
		-no-feature-makeqpf
		-no-feature-qev
		-no-feature-qtattributionsscanner
		-no-feature-windeployqt
		-no-feature-winrtrunner
	)

	local i module=${PN}
	case ${PN} in
		linguist-tools) module=linguist ;;
		*) ;;
	esac
	for i in assistant designer linguist pixeltool qdbus qdoc qtdiag qtpaths qtplugininfo; do
		[[ ${module} != ${i} ]] && qmakeargs+=( -no-feature-${i} )
	done

	# allow the ebuild to override what we set here
	myqmakeargs=( "${qmakeargs[@]}" "${myqmakeargs[@]}" )

	mkdir -p "${QT5_BUILD_DIR}" || die
	qt5_qmake "${QT5_BUILD_DIR}"
	cp qttools-config.pri "${QT5_BUILD_DIR}" || die
}

# @FUNCTION: qt5_qmake_args
# @INTERNAL
# @DESCRIPTION:
# Helper function to get the various toolchain-related variables.
qt5_qmake_args() {
	echo \
		QMAKE_AR=\"$(tc-getAR)\" \
		QMAKE_CC=\"$(tc-getCC)\" \
		QMAKE_LINK_C=\"$(tc-getCC)\" \
		QMAKE_LINK_C_SHLIB=\"$(tc-getCC)\" \
		QMAKE_CXX=\"$(tc-getCXX)\" \
		QMAKE_LINK=\"$(tc-getCXX)\" \
		QMAKE_LINK_SHLIB=\"$(tc-getCXX)\" \
		QMAKE_OBJCOPY=\"$(tc-getOBJCOPY)\" \
		QMAKE_RANLIB= \
		QMAKE_STRIP=\"$(tc-getSTRIP)\" \
		QMAKE_CFLAGS=\"${CFLAGS}\" \
		QMAKE_CFLAGS_RELEASE= \
		QMAKE_CFLAGS_DEBUG= \
		QMAKE_CXXFLAGS=\"${CXXFLAGS}\" \
		QMAKE_CXXFLAGS_RELEASE= \
		QMAKE_CXXFLAGS_DEBUG= \
		QMAKE_LFLAGS=\"${LDFLAGS}\" \
		QMAKE_LFLAGS_RELEASE= \
		QMAKE_LFLAGS_DEBUG=
}

# @FUNCTION: qt5_qmake
# @INTERNAL
# @DESCRIPTION:
# Helper function that runs qmake in the current target subdir.
# Intended to be called by qt5_foreach_target_subdir().
qt5_qmake() {
	local projectdir=${PWD/#${QT5_BUILD_DIR}/${S}}
	local qmakepath=
	if [[ ${QT5_MODULE} == qtbase ]]; then
		qmakepath=${QT5_BUILD_DIR}/bin
	else
		qmakepath=${QT5_BINDIR}
	fi

	"${qmakepath}"/qmake \
		"${projectdir}" \
		CONFIG+=$(usex debug debug release) \
		CONFIG-=$(usex debug release debug) \
		QMAKE_AR="$(tc-getAR) cqs" \
		QMAKE_CC="$(tc-getCC)" \
		QMAKE_LINK_C="$(tc-getCC)" \
		QMAKE_LINK_C_SHLIB="$(tc-getCC)" \
		QMAKE_CXX="$(tc-getCXX)" \
		QMAKE_LINK="$(tc-getCXX)" \
		QMAKE_LINK_SHLIB="$(tc-getCXX)" \
		QMAKE_OBJCOPY="$(tc-getOBJCOPY)" \
		QMAKE_RANLIB= \
		QMAKE_STRIP="$(tc-getSTRIP)" \
		QMAKE_CFLAGS="${CFLAGS}" \
		QMAKE_CFLAGS_RELEASE= \
		QMAKE_CFLAGS_DEBUG= \
		QMAKE_CXXFLAGS="${CXXFLAGS}" \
		QMAKE_CXXFLAGS_RELEASE= \
		QMAKE_CXXFLAGS_DEBUG= \
		QMAKE_LFLAGS="${LDFLAGS}" \
		QMAKE_LFLAGS_RELEASE= \
		QMAKE_LFLAGS_DEBUG= \
		"${myqmakeargs[@]}" \
		|| die "qmake failed (${projectdir#${S}/})"
}

# @FUNCTION: qt5_install_module_config
# @INTERNAL
# @DESCRIPTION:
# Creates and installs gentoo-specific ${PN}-qconfig.{h,pri} and
# ${PN}-qmodule.pri files.
qt5_install_module_config() {
	local x qconfig_add= qconfig_remove= qprivateconfig_add= qprivateconfig_remove=

	> "${T}"/${PN}-qconfig.h
	> "${T}"/${PN}-qconfig.pri
	> "${T}"/${PN}-qmodule.pri

	# generate qconfig_{add,remove} and ${PN}-qconfig.h
	for x in "${QT5_GENTOO_CONFIG[@]}"; do
		local flag=${x%%:*}
		x=${x#${flag}:}
		local feature=${x%%:*}
		x=${x#${feature}:}
		local macro=${x}
		macro=$(tr 'a-z-' 'A-Z_' <<< "${macro}")

		if [[ -z ${flag} ]] || { [[ ${flag} != '!' ]] && use ${flag}; }; then
			[[ -n ${feature} ]] && qconfig_add+=" ${feature}"
			[[ -n ${macro} ]] && echo "#define QT_${macro}" >> "${T}"/${PN}-qconfig.h
		else
			[[ -n ${feature} ]] && qconfig_remove+=" ${feature}"
			[[ -n ${macro} ]] && echo "#define QT_NO_${macro}" >> "${T}"/${PN}-qconfig.h
		fi
	done

	# install ${PN}-qconfig.h
	[[ -s ${T}/${PN}-qconfig.h ]] && (
		insinto "${QT5_HEADERDIR#${EPREFIX}}"/Gentoo
		doins "${T}"/${PN}-qconfig.h
	)

	# generate and install ${PN}-qconfig.pri
	[[ -n ${qconfig_add} ]] && echo "QCONFIG_ADD=${qconfig_add}" >> "${T}"/${PN}-qconfig.pri
	[[ -n ${qconfig_remove} ]] && echo "QCONFIG_REMOVE=${qconfig_remove}" >> "${T}"/${PN}-qconfig.pri
	[[ -s ${T}/${PN}-qconfig.pri ]] && (
		insinto "${QT5_ARCHDATADIR#${EPREFIX}}"/mkspecs/gentoo
		doins "${T}"/${PN}-qconfig.pri
	)

	# generate qprivateconfig
	for x in "${QT5_GENTOO_PRIVATE_CONFIG[@]}"; do
		local flag=${x%%:*}
		x=${x#${flag}:}
		local feature=${x%%:*}
		x=${x#${feature}:}

		if [[ -z ${flag} ]] || { [[ ${flag} != '!' ]] && use ${flag}; }; then
			[[ -n ${feature} ]] && qprivateconfig_add+=" ${feature}"
		else
			[[ -n ${feature} ]] && qprivateconfig_remove+=" ${feature}"
		fi
	done

	# generate and install ${PN}-qmodule.pri
	[[ -n ${qprivateconfig_add} ]] && echo "QT.global_private.enabled_features = ${qprivateconfig_add}" >> "${T}"/${PN}-qmodule.pri
	[[ -n ${qprivateconfig_remove} ]] && echo "QT.global_private.disabled_features = ${qprivateconfig_remove}" >> "${T}"/${PN}-qmodule.pri
	[[ -s ${T}/${PN}-qmodule.pri ]] && (
		insinto "${QT5_ARCHDATADIR#${EPREFIX}}"/mkspecs/gentoo
		doins "${T}"/${PN}-qmodule.pri
	)

	# install the original {qconfig,qmodule}.pri from qtcore
	[[ ${PN} == qtcore ]] && (
		insinto "${QT5_ARCHDATADIR#${EPREFIX}}"/mkspecs/gentoo
		newins "${D}${QT5_ARCHDATADIR}"/mkspecs/qconfig.pri qconfig-qtcore.pri
		newins "${D}${QT5_ARCHDATADIR}"/mkspecs/qmodule.pri qmodule-qtcore.pri
	)
}

# @FUNCTION: qt5_regenerate_global_configs
# @INTERNAL
# @DESCRIPTION:
# Generates Gentoo-specific qconfig.{h,pri} and qmodule.pri according to the
# build configuration.
# Don't call die here because dying in pkg_post{inst,rm} only makes things worse.
qt5_regenerate_global_configs() {
	einfo "Regenerating gentoo-qconfig.h"

	find "${ROOT}${QT5_HEADERDIR}"/Gentoo \
		-name '*-qconfig.h' -a \! -name 'gentoo-qconfig.h' -type f \
		-execdir cat '{}' + | sort -u > "${T}"/gentoo-qconfig.h

	[[ -s ${T}/gentoo-qconfig.h ]] || ewarn "Generated gentoo-qconfig.h is empty"
	cp "${T}"/gentoo-qconfig.h "${ROOT}${QT5_HEADERDIR}"/Gentoo/gentoo-qconfig.h \
		|| eerror "Failed to install new gentoo-qconfig.h"

	einfo "Updating QT_CONFIG in qconfig.pri"

	local qconfig_pri=${ROOT}${QT5_ARCHDATADIR}/mkspecs/qconfig.pri
	local qconfig_pri_orig=${ROOT}${QT5_ARCHDATADIR}/mkspecs/gentoo/qconfig-qtcore.pri
	if [[ -f ${qconfig_pri} ]]; then
		local x qconfig_add= qconfig_remove=
		local qt_config new_qt_config=
		if [[ -f ${qconfig_pri_orig} ]]; then
			qt_config=$(sed -n 's/^QT_CONFIG\s*+=\s*//p' "${qconfig_pri_orig}")
		else
			qt_config=$(sed -n 's/^QT_CONFIG\s*+=\s*//p' "${qconfig_pri}")
		fi

		# generate list of QT_CONFIG entries from the existing list,
		# appending QCONFIG_ADD and excluding QCONFIG_REMOVE
		eshopts_push -s nullglob
		for x in "${ROOT}${QT5_ARCHDATADIR}"/mkspecs/gentoo/*-qconfig.pri; do
			qconfig_add+=" $(sed -n 's/^QCONFIG_ADD=\s*//p' "${x}")"
			qconfig_remove+=" $(sed -n 's/^QCONFIG_REMOVE=\s*//p' "${x}")"
		done
		eshopts_pop
		for x in ${qt_config} ${qconfig_add}; do
			if ! has "${x}" ${new_qt_config} ${qconfig_remove}; then
				new_qt_config+=" ${x}"
			fi
		done

		# now replace the existing QT_CONFIG with the generated list
		sed -i -e "s/^QT_CONFIG\s*+=.*/QT_CONFIG +=${new_qt_config}/" \
			"${qconfig_pri}" || eerror "Failed to sed QT_CONFIG in ${qconfig_pri}"
	else
		ewarn "${qconfig_pri} does not exist or is not a regular file"
	fi

	einfo "Updating QT.global_private in qmodule.pri"

	local qmodule_pri=${ROOT}${QT5_ARCHDATADIR}/mkspecs/qmodule.pri
	local qmodule_pri_orig=${ROOT}${QT5_ARCHDATADIR}/mkspecs/gentoo/qmodule-qtcore.pri
	if [[ -f ${qmodule_pri} && -f ${qmodule_pri_orig} ]]; then
		local x
		local qprivateconfig_enabled= qprivateconfig_disabled=
		local qprivateconfig_orig_enabled= qprivateconfig_orig_disabled=
		local new_qprivateconfig_enabled= new_qprivateconfig_disabled=

		# generate lists of QT.global_private.{dis,en}abled_features
		qprivateconfig_orig_enabled="$(sed -n 's/^QT.global_private.enabled_features\s=\s*//p' "${qmodule_pri_orig}")"
		qprivateconfig_orig_disabled="$(sed -n 's/^QT.global_private.disabled_features\s=\s*//p' "${qmodule_pri_orig}")"
		eshopts_push -s nullglob
		for x in "${ROOT}${QT5_ARCHDATADIR}"/mkspecs/gentoo/*-qmodule.pri; do
			qprivateconfig_enabled+=" $(sed -n 's/^QT.global_private.enabled_features\s=\s*//p' "${x}")"
			qprivateconfig_disabled+=" $(sed -n 's/^QT.global_private.disabled_features\s=\s*//p' "${x}")"
		done
		eshopts_pop

		# anything enabled is enabled, but anything disabled is
		# only disabled if it isn't enabled somewhere else.
		# this is because we need to forcibly disable some stuff
		# in qtcore to support split qtbase.
		new_qprivateconfig_enabled=${qprivateconfig_enabled}
		for x in ${qprivateconfig_disabled}; do
			if ! has "${x}" ${qprivateconfig_enabled}; then
				new_qprivateconfig_disabled+=" ${x}"
			fi
		done

		# check all items from the original qtcore qmodule.pri,
		# and add them to the appropriate list if not overridden
		# elsewhere
		for x in ${qprivateconfig_orig_enabled}; do
			if ! has "${x}" ${new_qprivateconfig_enabled} ${new_qprivateconfig_disabled}; then
				new_qprivateconfig_enabled+=" ${x}"
			fi
		done
		for x in ${qprivateconfig_orig_disabled}; do
			if ! has "${x}" ${new_qprivateconfig_enabled} ${new_qprivateconfig_disabled}; then
				new_qprivateconfig_disabled+=" ${x}"
			fi
		done

		# now replace the existing QT.global_private.{dis,en}abled_features
		# with the generated list
		sed \
			-e "s/^QT.global_private.enabled_features\s*=.*/QT.global_private.enabled_features =${new_qprivateconfig_enabled}/" \
			-e "s/^QT.global_private.disabled_features\s*=.*/QT.global_private.disabled_features =${new_qprivateconfig_disabled}/" \
			-i "${qmodule_pri}" || eerror "Failed to sed QT.global_private.enabled_features in ${qmodule_pri}"
	else
		ewarn "${qmodule_pri} or ${qmodule_pri_orig} does not exist or is not a regular file"
	fi
}
