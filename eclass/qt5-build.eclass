# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: qt5-build.eclass
# @MAINTAINER:
# qt@gentoo.org
# @AUTHOR:
# Davide Pesavento <pesa@gentoo.org>
# @BLURB: Eclass for Qt5 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt5.
# Requires EAPI 5 or 6.

if [[ ${CATEGORY} != dev-qt ]]; then
	die "qt5-build.eclass is only to be used for building Qt 5."
fi

case ${EAPI} in
	5|6)	: ;;
	*)	die "qt5-build.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

# @ECLASS-VARIABLE: QT5_MODULE
# @DESCRIPTION:
# The upstream name of the module this package belongs to. Used for
# SRC_URI and EGIT_REPO_URI. Must be defined before inheriting the eclass.
: ${QT5_MODULE:=${PN}}

# @ECLASS-VARIABLE: QT5_TARGET_SUBDIRS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array variable containing the source directories that should be built.
# All paths must be relative to ${S}.

# @ECLASS-VARIABLE: QT5_GENTOO_CONFIG
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of <useflag:feature:macro> triplets that are evaluated in src_install
# to generate the per-package list of enabled QT_CONFIG features and macro
# definitions, which are then merged together with all other Qt5 packages
# installed on the system to obtain the global qconfig.{h,pri} files.

# @ECLASS-VARIABLE: VIRTUALX_REQUIRED
# @DESCRIPTION:
# For proper description see virtualx.eclass man page.
# Here we redefine default value to be manual, if your package needs virtualx
# for tests you should proceed with setting VIRTUALX_REQUIRED=test.
: ${VIRTUALX_REQUIRED:=manual}

[[ ${EAPI} == 5 ]] && inherit multilib
inherit eutils flag-o-matic toolchain-funcs versionator virtualx

HOMEPAGE="https://www.qt.io/"

QT5_MINOR_VERSION=$(get_version_component_range 2)
readonly QT5_MINOR_VERSION

if [[ ${QT5_MINOR_VERSION} -ge 7 ]]; then
	LICENSE="|| ( GPL-2 GPL-3 LGPL-3 ) FDL-1.3"
else
	LICENSE="|| ( LGPL-2.1 LGPL-3 ) FDL-1.3"
fi

if [[ ${QT5_MINOR_VERSION} -ge 6 ]]; then
	SLOT=5/$(get_version_component_range 1-2)
else
	SLOT=5
fi

case ${PV} in
	5.9999)
		# git dev branch
		QT5_BUILD_TYPE="live"
		EGIT_BRANCH="dev"
		;;
	5.?.9999)
		# git stable branch
		QT5_BUILD_TYPE="live"
		EGIT_BRANCH=${PV%.9999}
		;;
	*_alpha*|*_beta*|*_rc*)
		# development release
		QT5_BUILD_TYPE="release"
		MY_P=${QT5_MODULE}-opensource-src-${PV/_/-}
		SRC_URI="https://download.qt.io/development_releases/qt/${PV%.*}/${PV/_/-}/submodules/${MY_P}.tar.xz"
		S=${WORKDIR}/${MY_P}
		;;
	*)
		# official stable release
		QT5_BUILD_TYPE="release"
		MY_P=${QT5_MODULE}-opensource-src-${PV}
		SRC_URI="https://download.qt.io/official_releases/qt/${PV%.*}/${PV}/submodules/${MY_P}.tar.xz"
		S=${WORKDIR}/${MY_P}
		;;
esac
readonly QT5_BUILD_TYPE

EGIT_REPO_URI=(
	"git://code.qt.io/qt/${QT5_MODULE}.git"
	"https://code.qt.io/git/qt/${QT5_MODULE}.git"
	"https://github.com/qtproject/${QT5_MODULE}.git"
)
[[ ${QT5_BUILD_TYPE} == live ]] && inherit git-r3

# @ECLASS-VARIABLE: QT5_BUILD_DIR
# @DESCRIPTION:
# Build directory for out-of-source builds.
case ${QT5_BUILD_TYPE} in
	live)    : ${QT5_BUILD_DIR:=${S}_build} ;;
	release) : ${QT5_BUILD_DIR:=${S}} ;; # workaround for bug 497312
esac

IUSE="debug test"

[[ ${PN} == qtwebkit ]] && RESTRICT+=" mirror" # bug 524584
[[ ${QT5_BUILD_TYPE} == release ]] && RESTRICT+=" test" # bug 457182

DEPEND="
	dev-lang/perl
	virtual/pkgconfig
"
if [[ ${PN} != qttest ]]; then
	DEPEND+=" test? ( ~dev-qt/qttest-${PV} )"
fi
RDEPEND="
	dev-qt/qtchooser
"


######  Phase functions  ######

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install src_test pkg_postinst pkg_postrm

# @FUNCTION: qt5-build_src_unpack
# @DESCRIPTION:
# Unpacks the sources.
qt5-build_src_unpack() {
	local min_gcc4_minor_version=5
	if [[ ${QT5_MINOR_VERSION} -ge 7 || ${PN} == qtwebengine ]]; then
		min_gcc4_minor_version=7
	fi
	if [[ $(gcc-major-version) -lt 4 ]] || \
	   [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt ${min_gcc4_minor_version} ]]; then
		if [[ ${QT5_MINOR_VERSION} -ge 6 ]]; then
			eerror "GCC version 4.${min_gcc4_minor_version} or later is required to build this package"
			die "GCC 4.${min_gcc4_minor_version} or later required"
		else
			ewarn
			ewarn "Using a GCC version lower than 4.${min_gcc4_minor_version} is not supported"
			ewarn
		fi
	fi

	# bug 307861
	if [[ ${PN} == qtwebengine || ${PN} == qtwebkit ]]; then
		eshopts_push -s extglob
		if is-flagq '-g?(gdb)?([1-9])'; then
			ewarn
			ewarn "You have enabled debug info (probably have -g or -ggdb in your CFLAGS/CXXFLAGS)."
			ewarn "You may experience really long compilation times and/or increased memory usage."
			ewarn "If compilation fails, please try removing -g/-ggdb before reporting a bug."
			ewarn
		fi
		eshopts_pop
	fi

	case ${QT5_BUILD_TYPE} in
		live)    git-r3_src_unpack ;;
		release) default ;;
	esac
}

# @FUNCTION: qt5-build_src_prepare
# @DESCRIPTION:
# Prepares the environment and patches the sources if necessary.
qt5-build_src_prepare() {
	qt5_prepare_env

	if [[ ${QT5_MODULE} == qtbase ]]; then
		qt5_symlink_tools_to_build_dir

		# Avoid unnecessary qmake recompilations
		sed -i -re "s|^if true;.*(\[ '\!').*(\"\\\$outpath/bin/qmake\".*)|if \1 -e \2 then|" \
			configure || die "sed failed (skip qmake bootstrap)"

		# Respect CC, CXX, *FLAGS, MAKEOPTS and EXTRA_EMAKE when bootstrapping qmake
		sed -i -e "/outpath\/qmake\".*\"\$MAKE\")/ s:): \
			${MAKEOPTS} ${EXTRA_EMAKE} 'CC=$(tc-getCC)' 'CXX=$(tc-getCXX)' \
			'QMAKE_CFLAGS=${CFLAGS}' 'QMAKE_CXXFLAGS=${CXXFLAGS}' 'QMAKE_LFLAGS=${LDFLAGS}'&:" \
			-e 's/\(setBootstrapVariable\s\+\|EXTRA_C\(XX\)\?FLAGS=.*\)QMAKE_C\(XX\)\?FLAGS_\(DEBUG\|RELEASE\).*/:/' \
			configure || die "sed failed (respect env for qmake build)"
		sed -i -e '/^CPPFLAGS\s*=/ s/-g //' \
			qmake/Makefile.unix || die "sed failed (CPPFLAGS for qmake build)"

		# Respect CXX in bsymbolic_functions, fvisibility, precomp, and a few other tests
		sed -i -e "/^QMAKE_CONF_COMPILER=/ s:=.*:=\"$(tc-getCXX)\":" \
			configure || die "sed failed (QMAKE_CONF_COMPILER)"

		# Respect toolchain and flags in config.tests
		find config.tests/unix -name '*.test' -type f -execdir \
			sed -i -re '/(bin\/qmake|QMAKE")/ s/-nocache //' '{}' + || die

		# Don't inject -msse/-mavx/... into CXXFLAGS when detecting
		# compiler support for extended instruction sets (bug 552942)
		find config.tests/common -name '*.pro' -type f -execdir \
			sed -i -e '/QMAKE_CXXFLAGS\s*+=/ d' '{}' + || die

		# Don't add -O3 to CXXFLAGS (bug 549140)
		sed -i -e '/CONFIG\s*+=/ s/optimize_full//' \
			src/{corelib/corelib,gui/gui}.pro || die "sed failed (optimize_full)"
	fi

	if [[ ${EAPI} == 5 ]]; then
		[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
		epatch_user
	else
		default
	fi
}

# @FUNCTION: qt5-build_src_configure
# @DESCRIPTION:
# Runs qmake in the target directories. For packages
# in qtbase, ./configure is also run before qmake.
qt5-build_src_configure() {
	if [[ ${QT5_MODULE} == qtbase ]]; then
		qt5_base_configure
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

		local qmake_install_target=install_qmake
		if [[ ${QT5_MINOR_VERSION} -ge 7 ]]; then
			# qmake/qmake-aux.pro
			qmake_install_target=sub-qmake-qmake-aux-pro-install_subtargets
		fi

		set -- emake INSTALL_ROOT="${D}" \
			${qmake_install_target} \
			install_{syncqt,mkspecs,global_docs}
		einfo "Running $*"
		"$@"

		popd >/dev/null || die

		docompress -x "${QT5_DOCDIR#${EPREFIX}}"/global

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
	fi

	qt5_install_module_qconfigs
	prune_libtool_files
}

# @FUNCTION: qt5-build_pkg_postinst
# @DESCRIPTION:
# Regenerate configuration after installation or upgrade/downgrade.
qt5-build_pkg_postinst() {
	qt5_regenerate_global_qconfigs
}

# @FUNCTION: qt5-build_pkg_postrm
# @DESCRIPTION:
# Regenerate configuration when a module is completely removed.
qt5-build_pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${PN} != qtcore ]]; then
		qt5_regenerate_global_qconfigs
	fi
}


######  Public helpers  ######

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
	QT5_DOCDIR=${QT5_PREFIX}/share/doc/qt-${PV}
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

	local die_args=()
	[[ ${EAPI} != 5 ]] && die_args+=(-n)

	local subdir=
	for subdir in "${QT5_TARGET_SUBDIRS[@]}"; do
		if [[ ${EBUILD_PHASE} == test ]]; then
			subdir=tests/auto${subdir#src}
			[[ -d ${S}/${subdir} ]] || continue
		fi

		local msg="Running $* ${subdir:+in ${subdir}}"
		einfo "${msg}"

		mkdir -p "${QT5_BUILD_DIR}/${subdir}" || die "${die_args[@]}" || return $?
		pushd "${QT5_BUILD_DIR}/${subdir}" >/dev/null || die "${die_args[@]}" || return $?

		"$@" || die "${die_args[@]}" "${msg} failed" || return $?

		popd >/dev/null || die "${die_args[@]}" || return $?
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

		# configure in release mode by default,
		# override via the CONFIG qmake variable
		-release
		-no-separate-debug-info

		# no need to forcefully build host tools in optimized mode,
		# just follow the overall debug/release build type
		$([[ ${QT5_MINOR_VERSION} -ge 6 ]] && echo -no-optimized-tools)

		# licensing stuff
		-opensource -confirm-license

		# autodetect the highest supported version of the C++ standard
		#-c++std <c++11|c++14|c++1z>

		# build shared libraries
		-shared

		# always enable large file support
		$([[ ${QT5_MINOR_VERSION} -lt 8 ]] && echo -largefile)

		# disabling accessibility is not recommended by upstream, as
		# it will break QStyle and may break other internal parts of Qt
		-accessibility

		# disable all SQL drivers by default, override in qtsql
		-no-sql-db2 -no-sql-ibase -no-sql-mysql -no-sql-oci -no-sql-odbc
		-no-sql-psql -no-sql-sqlite -no-sql-sqlite2 -no-sql-tds

		# ensure the QML debugging support (qmltooling) is built in qtdeclarative
		$([[ ${QT5_MINOR_VERSION} -ge 6 ]] && echo -qml-debug)

		# MIPS DSP instruction set extensions
		$(is-flagq -mno-dsp   && echo -no-mips_dsp)
		$(is-flagq -mno-dspr2 && echo -no-mips_dspr2)

		# use pkg-config to detect include and library paths
		-pkg-config

		# prefer system libraries (only common hard deps here)
		-system-zlib
		-system-pcre
		# TODO after bug 581054
		#$([[ ${QT5_MINOR_VERSION} -ge 7 ]] && echo -system-doubleconversion)

		# disable everything to prevent automagic deps (part 1)
		-no-mtdev
		-no-journald
		$([[ ${QT5_MINOR_VERSION} -ge 6 ]] && echo -no-syslog)
		-no-libpng -no-libjpeg
		-no-freetype -no-harfbuzz
		-no-openssl -no-libproxy
		-no-xkbcommon-x11 -no-xkbcommon-evdev
		-no-xinput2 -no-xcb-xlib

		# cannot use -no-gif because there is no way to override it later
		#-no-gif

		# always enable glib event loop support
		-glib

		# disable everything to prevent automagic deps (part 2)
		-no-pulseaudio -no-alsa
		$([[ ${QT5_MINOR_VERSION} -ge 7 ]] && echo -no-gtk || echo -no-gtkstyle)

		# exclude examples and tests from default build
		-nomake examples
		-nomake tests
		-no-compile-examples

		# disable rpath on non-prefix (bugs 380415 and 417169)
		$(usex prefix '' -no-rpath)

		# print verbose information about each configure test
		-verbose

		# obsolete flag, does nothing
		#-nis

		# always enable iconv support
		-iconv

		# disable everything to prevent automagic deps (part 3)
		-no-cups -no-evdev -no-tslib -no-icu -no-fontconfig -no-dbus

		# let portage handle stripping
		-no-strip

		# precompiled headers can cause problems on hardened, so turn them off
		-no-pch

		# link-time code generation is not something we want to enable by default
		$([[ ${QT5_MINOR_VERSION} -ge 6 ]] && echo -no-ltcg)

		# reduced relocations cause major breakage on at least arm and ppc, so
		# don't specify anything and let the configure figure out if they are
		# supported; see also https://bugreports.qt.io/browse/QTBUG-36129
		#-reduce-relocations

		# let configure automatically detect if GNU gold is available
		#-use-gold-linker

		# disable all platform plugins by default, override in qtgui
		-no-xcb -no-eglfs -no-kms
		$([[ ${QT5_MINOR_VERSION} -ge 6 ]] && echo -no-gbm)
		-no-directfb -no-linuxfb
		$([[ ${QT5_MINOR_VERSION} -ge 6 ]] && echo -no-mirclient)

		# disable undocumented X11-related flags, override in qtgui
		# (not shown in ./configure -help output)
		-no-xkb -no-xrender

		# disable obsolete/unused X11-related flags
		$([[ ${QT5_MINOR_VERSION} -lt 8 ]] && echo -no-mitshm -no-xcursor -no-xfixes -no-xrandr -no-xshape -no-xsync)

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

		# disable gstreamer by default, override in qtmultimedia
		-no-gstreamer

		# use upstream default
		#-no-system-proxies

		# do not build with -Werror
		-no-warnings-are-errors

		# module-specific options
		"${myconf[@]}"
	)

	pushd "${QT5_BUILD_DIR}" >/dev/null || die

	einfo "Configuring with: ${conf[@]}"
	"${S}"/configure "${conf[@]}" || die "configure failed"

	popd >/dev/null || die
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

# @FUNCTION: qt5_install_module_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Creates and installs gentoo-specific ${PN}-qconfig.{h,pri} files.
qt5_install_module_qconfigs() {
	local x qconfig_add= qconfig_remove=

	> "${T}"/${PN}-qconfig.h
	> "${T}"/${PN}-qconfig.pri

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
}

# @FUNCTION: qt5_regenerate_global_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Generates Gentoo-specific qconfig.{h,pri} according to the build configuration.
# Don't call die here because dying in pkg_post{inst,rm} only makes things worse.
qt5_regenerate_global_qconfigs() {
	einfo "Regenerating gentoo-qconfig.h"

	find "${ROOT%/}${QT5_HEADERDIR}"/Gentoo \
		-name '*-qconfig.h' -a \! -name 'gentoo-qconfig.h' -type f \
		-execdir cat '{}' + | sort -u > "${T}"/gentoo-qconfig.h

	[[ -s ${T}/gentoo-qconfig.h ]] || ewarn "Generated gentoo-qconfig.h is empty"
	mv -f "${T}"/gentoo-qconfig.h "${ROOT%/}${QT5_HEADERDIR}"/Gentoo/gentoo-qconfig.h \
		|| eerror "Failed to install new gentoo-qconfig.h"

	einfo "Updating QT_CONFIG in qconfig.pri"

	local qconfig_pri=${ROOT%/}${QT5_ARCHDATADIR}/mkspecs/qconfig.pri
	if [[ -f ${qconfig_pri} ]]; then
		local x qconfig_add= qconfig_remove=
		local qt_config=$(sed -n 's/^QT_CONFIG\s*+=\s*//p' "${qconfig_pri}")
		local new_qt_config=

		# generate list of QT_CONFIG entries from the existing list,
		# appending QCONFIG_ADD and excluding QCONFIG_REMOVE
		eshopts_push -s nullglob
		for x in "${ROOT%/}${QT5_ARCHDATADIR}"/mkspecs/gentoo/*-qconfig.pri; do
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
}
