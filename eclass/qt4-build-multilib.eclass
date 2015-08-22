# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: qt4-build-multilib.eclass
# @MAINTAINER:
# Qt herd <qt@gentoo.org>
# @AUTHOR:
# Davide Pesavento <pesa@gentoo.org>
# @BLURB: Eclass for Qt4 split ebuilds with multilib support.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt4.
# Requires EAPI 5.

case ${EAPI} in
	5)	: ;;
	*)	die "qt4-build-multilib.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

inherit eutils flag-o-matic multilib multilib-minimal toolchain-funcs

HOMEPAGE="https://www.qt.io/"
LICENSE="|| ( LGPL-2.1 LGPL-3 GPL-3 ) FDL-1.3"
SLOT="4"

case ${PV} in
	4.?.9999)
		# git stable branch
		QT4_BUILD_TYPE="live"
		EGIT_BRANCH=${PV%.9999}
		;;
	*)
		# official stable release
		QT4_BUILD_TYPE="release"
		MY_P=qt-everywhere-opensource-src-${PV/_/-}
		SRC_URI="http://download.qt.io/official_releases/qt/${PV%.*}/${PV}/${MY_P}.tar.gz"
		S=${WORKDIR}/${MY_P}
		;;
esac

EGIT_REPO_URI=(
	"git://code.qt.io/qt/qt.git"
	"https://code.qt.io/git/qt/qt.git"
	"https://github.com/qtproject/qt.git"
)
[[ ${QT4_BUILD_TYPE} == live ]] && inherit git-r3

if [[ ${PN} != qttranslations ]]; then
	IUSE="aqua debug pch"
	[[ ${PN} != qtxmlpatterns ]] && IUSE+=" +exceptions"
fi

DEPEND="
	dev-lang/perl
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"
RDEPEND="
	dev-qt/qtchooser
	abi_x86_32? ( !app-emulation/emul-linux-x86-qtlibs[-abi_x86_32(-)] )
"


# src_{configure,compile,test,install} are inherited from multilib-minimal
EXPORT_FUNCTIONS src_unpack src_prepare pkg_postinst pkg_postrm

multilib_src_configure()	{ qt4_multilib_src_configure; }
multilib_src_compile()		{ qt4_multilib_src_compile; }
multilib_src_test()		{ qt4_multilib_src_test; }
multilib_src_install()		{ qt4_multilib_src_install; }
multilib_src_install_all()	{ qt4_multilib_src_install_all; }


# @ECLASS-VARIABLE: PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array variable containing all the patches to be applied. This variable
# is expected to be defined in the global scope of ebuilds. Make sure to
# specify the full path. This variable is used in src_prepare phase.
#
# Example:
# @CODE
#	PATCHES=(
#		"${FILESDIR}/mypatch.patch"
#		"${FILESDIR}/mypatch2.patch"
#	)
# @CODE

# @ECLASS-VARIABLE: QT4_TARGET_DIRECTORIES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Space-separated list of directories that will be configured,
# compiled, and installed. All paths must be relative to ${S}.

# @ECLASS-VARIABLE: QCONFIG_ADD
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of options that must be added to QT_CONFIG in qconfig.pri

# @ECLASS-VARIABLE: QCONFIG_REMOVE
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of options that must be removed from QT_CONFIG in qconfig.pri

# @ECLASS-VARIABLE: QCONFIG_DEFINE
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of macros that must be defined in QtCore/qconfig.h


######  Phase functions  ######

# @FUNCTION: qt4-build-multilib_src_unpack
# @DESCRIPTION:
# Unpacks the sources.
qt4-build-multilib_src_unpack() {
	if [[ $(gcc-major-version) -lt 4 ]] || [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 4 ]]; then
		ewarn
		ewarn "Using a GCC version lower than 4.4 is not supported."
		ewarn
	fi

	if [[ ${PN} == qtwebkit ]]; then
		eshopts_push -s extglob
		if is-flagq '-g?(gdb)?([1-9])'; then
			ewarn
			ewarn "You have enabled debug info (probably have -g or -ggdb in your CFLAGS/CXXFLAGS)."
			ewarn "You may experience really long compilation times and/or increased memory usage."
			ewarn "If compilation fails, please try removing -g/-ggdb before reporting a bug."
			ewarn "For more info check out https://bugs.gentoo.org/307861"
			ewarn
		fi
		eshopts_pop
	fi

	case ${QT4_BUILD_TYPE} in
		live)    git-r3_src_unpack ;;
		release) default ;;
	esac
}

# @FUNCTION: qt4-build-multilib_src_prepare
# @DESCRIPTION:
# Prepare the sources before the configure phase. Strip CFLAGS if necessary, and fix
# the build system in order to respect CFLAGS/CXXFLAGS/LDFLAGS specified in make.conf.
qt4-build-multilib_src_prepare() {
	if [[ ${PN} != qtcore ]]; then
		# avoid unnecessary qmake recompilations
		sed -i -e 's/^if true;/if false;/' configure \
			|| die "sed failed (skip qmake bootstrap)"
	fi

	# skip X11 tests in non-gui packages to avoid spurious dependencies
	if has ${PN} qtbearer qtcore qtdbus qtscript qtsql qttest qttranslations qtxmlpatterns; then
		sed -i -e '/^if.*PLATFORM_X11.*CFG_GUI/,/^fi$/d' configure \
			|| die "sed failed (skip X11 tests)"
	fi

	if [[ ${PN} == qtcore ]]; then
		# Bug 373061
		# qmake bus errors with -O2 or -O3 but -O1 works
		if [[ ${CHOST} == *86*-apple-darwin* ]]; then
			replace-flags -O[23] -O1
		fi

		# Bug 503500
		# undefined reference with -Os and --as-needed
		if use x86 || use_if_iuse abi_x86_32; then
			replace-flags -Os -O2
		fi
	fi

	if [[ ${PN} == qtdeclarative ]]; then
		# Bug 551560
		# gcc-4.8 ICE with -Os, fixed in 4.9
		if use x86 && [[ $(gcc-version) == 4.8 ]]; then
			replace-flags -Os -O2
		fi
	fi

	if [[ ${PN} == qtwebkit ]]; then
		# Bug 550780
		# various ICEs with graphite-related flags, gcc-5 works
		if [[ $(gcc-major-version) -lt 5 ]]; then
			filter-flags -fgraphite-identity -floop-strip-mine
		fi
	fi

	# Bug 261632
	if use ppc64; then
		append-flags -mminimal-toc
	fi

	# Read also AR from the environment
	sed -i -e 's/^SYSTEM_VARIABLES="/&AR /' \
		configure || die "sed SYSTEM_VARIABLES failed"

	# Reset QMAKE_*FLAGS_{RELEASE,DEBUG} variables,
	# or they will override the user's flags (via .qmake.cache)
	sed -i -e '/^SYSTEM_VARIABLES=/ i \
		QMakeVar set QMAKE_CFLAGS_RELEASE\
		QMakeVar set QMAKE_CFLAGS_DEBUG\
		QMakeVar set QMAKE_CXXFLAGS_RELEASE\
		QMakeVar set QMAKE_CXXFLAGS_DEBUG\
		QMakeVar set QMAKE_LFLAGS_RELEASE\
		QMakeVar set QMAKE_LFLAGS_DEBUG\n' \
		configure || die "sed QMAKE_*FLAGS_{RELEASE,DEBUG} failed"

	# Drop -nocache from qmake invocation in all configure tests, to ensure that the
	# correct toolchain and build flags are picked up from config.tests/.qmake.cache
	find config.tests/unix -name '*.test' -type f -execdir \
		sed -i -e '/bin\/qmake/s/-nocache//' '{}' + || die "sed -nocache failed"

	# compile.test needs additional patching so that it doesn't create another cache file
	# inside the test subdir, which would incorrectly override config.tests/.qmake.cache
	sed -i -e '/echo.*QT_BUILD_TREE.*\.qmake\.cache/d' \
		-e '/bin\/qmake/s/ "$SRCDIR/ "QT_BUILD_TREE=$OUTDIR"&/' \
		config.tests/unix/compile.test || die "sed compile.test failed"

	# Delete references to the obsolete /usr/X11R6 directory
	# On prefix, this also prevents looking at non-prefix stuff
	sed -i -re '/^QMAKE_(LIB|INC)DIR(_X11|_OPENGL|)\s+/ s/=.*/=/' \
		mkspecs/common/linux.conf \
		mkspecs/$(qt4_get_mkspec)/qmake.conf \
		|| die "sed QMAKE_(LIB|INC)DIR failed"

	if use_if_iuse aqua; then
		sed -i \
			-e '/^CONFIG/s:app_bundle::' \
			-e '/^CONFIG/s:plugin_no_soname:plugin_with_soname absolute_library_soname:' \
			mkspecs/$(qt4_get_mkspec)/qmake.conf \
			|| die "sed failed (aqua)"

		# we are crazy and build cocoa + qt3support
		if { ! in_iuse qt3support || use qt3support; } && [[ ${CHOST##*-darwin} -ge 9 ]]; then
			sed -i -e "/case \"\$PLATFORM,\$CFG_MAC_COCOA\" in/,/;;/ s|CFG_QT3SUPPORT=\"no\"|CFG_QT3SUPPORT=\"yes\"|" \
				configure || die "sed failed (cocoa + qt3support)"
		fi
	fi

	if [[ ${CHOST} == *-darwin* ]]; then
		# Set FLAGS and remove -arch, since our gcc-apple is multilib crippled (by design)
		sed -i \
			-e "s:QMAKE_CFLAGS_RELEASE.*=.*:QMAKE_CFLAGS_RELEASE=${CFLAGS}:" \
			-e "s:QMAKE_CXXFLAGS_RELEASE.*=.*:QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS}:" \
			-e "s:QMAKE_LFLAGS_RELEASE.*=.*:QMAKE_LFLAGS_RELEASE=-headerpad_max_install_names ${LDFLAGS}:" \
			-e "s:-arch\s\w*::g" \
			mkspecs/common/g++-macx.conf \
			|| die "sed g++-macx.conf failed"

		# Fix configure's -arch settings that appear in qmake/Makefile and also
		# fix arch handling (automagically duplicates our -arch arg and breaks
		# pch). Additionally disable Xarch support.
		sed -i \
			-e "s:-arch i386::" \
			-e "s:-arch ppc::" \
			-e "s:-arch x86_64::" \
			-e "s:-arch ppc64::" \
			-e "s:-arch \$i::" \
			-e "/if \[ ! -z \"\$NATIVE_64_ARCH\" \]; then/,/fi/ d" \
			-e "s:CFG_MAC_XARCH=yes:CFG_MAC_XARCH=no:g" \
			-e "s:-Xarch_x86_64::g" \
			-e "s:-Xarch_ppc64::g" \
			configure mkspecs/common/gcc-base-macx.conf mkspecs/common/g++-macx.conf \
			|| die "sed -arch/-Xarch failed"

		# On Snow Leopard don't fall back to 10.5 deployment target.
		if [[ ${CHOST} == *-apple-darwin10 ]]; then
			sed -i \
				-e "s:QMakeVar set QMAKE_MACOSX_DEPLOYMENT_TARGET.*:QMakeVar set QMAKE_MACOSX_DEPLOYMENT_TARGET 10.6:g" \
				-e "s:-mmacosx-version-min=10.[0-9]:-mmacosx-version-min=10.6:g" \
				configure mkspecs/common/g++-macx.conf \
				|| die "sed deployment target failed"
		fi
	fi

	if [[ ${CHOST} == *-solaris* ]]; then
		sed -i -e '/^QMAKE_LFLAGS_THREAD/a QMAKE_LFLAGS_DYNAMIC_LIST = -Wl,--dynamic-list,' \
			mkspecs/$(qt4_get_mkspec)/qmake.conf || die
	fi

	# apply patches
	[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
	epatch_user
}

qt4_multilib_src_configure() {
	qt4_prepare_env

	qt4_symlink_tools_to_build_dir

	# toolchain setup ('local -x' because of bug 532510)
	local -x \
		AR="$(tc-getAR) cqs" \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		LD=$(tc-getCXX) \
		MAKEFLAGS=${MAKEOPTS} \
		OBJCOPY=$(tc-getOBJCOPY) \
		OBJDUMP=$(tc-getOBJDUMP) \
		STRIP=$(tc-getSTRIP)

	# convert tc-arch to the values supported by Qt
	local arch=$(tc-arch)
	case ${arch} in
		amd64|x64-*)	arch=x86_64 ;;
		arm64|hppa)	arch=generic ;;
		ppc*-macos)	arch=ppc ;;
		ppc*)		arch=powerpc ;;
		sparc*)		arch=sparc ;;
		x86-macos)	arch=x86 ;;
		x86*)		arch=i386 ;;
	esac

	# configure arguments
	local conf=(
		# installation paths
		-prefix "${QT4_PREFIX}"
		-bindir "${QT4_BINDIR}"
		-libdir "${QT4_LIBDIR}"
		-docdir "${QT4_DOCDIR}"
		-headerdir "${QT4_HEADERDIR}"
		-plugindir "${QT4_PLUGINDIR}"
		-importdir "${QT4_IMPORTDIR}"
		-datadir "${QT4_DATADIR}"
		-translationdir "${QT4_TRANSLATIONDIR}"
		-sysconfdir "${QT4_SYSCONFDIR}"
		-examplesdir "${QT4_EXAMPLESDIR}"
		-demosdir "${QT4_DEMOSDIR}"

		# debug/release
		$(use_if_iuse debug && echo -debug || echo -release)
		-no-separate-debug-info

		# licensing stuff
		-opensource -confirm-license

		# build shared libraries
		-shared

		# skip recursive processing of .pro files at the end of configure
		# (we run qmake by ourselves), thus saving quite a bit of time
		-dont-process

		# always enable large file support
		-largefile

		# exceptions USE flag
		$(in_iuse exceptions && qt_use exceptions || echo -exceptions)

		# build STL support
		-stl

		# architecture/platform (mkspec)
		-arch ${arch}
		-platform $(qt4_get_mkspec)

		# instruction set support
		$(is-flagq -mno-mmx	&& echo -no-mmx)
		$(is-flagq -mno-3dnow	&& echo -no-3dnow)
		$(is-flagq -mno-sse	&& echo -no-sse)
		$(is-flagq -mno-sse2	&& echo -no-sse2)
		$(is-flagq -mno-sse3	&& echo -no-sse3)
		$(is-flagq -mno-ssse3	&& echo -no-ssse3)
		$(is-flagq -mno-sse4.1	&& echo -no-sse4.1)
		$(is-flagq -mno-sse4.2	&& echo -no-sse4.2)
		$(is-flagq -mno-avx	&& echo -no-avx)
		$(is-flagq -mfpu=*	&& ! is-flagq -mfpu=*neon* && echo -no-neon)

		# bug 367045
		$([[ ${CHOST} == *86*-apple-darwin* ]] && echo -no-ssse3)

		# prefer system libraries
		-system-zlib

		# exclude examples and demos from default build
		-nomake examples
		-nomake demos

		# disable rpath on non-prefix (bugs 380415 and 417169)
		$(usex prefix '' -no-rpath)

		# print verbose information about each configure test
		-verbose

		# precompiled headers don't work on hardened, where the flag is masked
		$(in_iuse pch && qt_use pch || echo -no-pch)

		# enable linker optimizations to reduce relocations, except on Solaris
		# where this flag seems to introduce major breakage to applications,
		# mostly to be seen as a core dump with the message:
		# "QPixmap: Must construct a QApplication before a QPaintDevice"
		$([[ ${CHOST} != *-solaris* ]] && echo -reduce-relocations)
	)

	if use_if_iuse aqua; then
		if [[ ${CHOST##*-darwin} -ge 9 ]]; then
			conf+=(
				# on (snow) leopard use the new (frameworked) cocoa code
				-cocoa -framework
				# add hint for the framework location
				-F"${QT4_LIBDIR}"
			)
		else
			conf+=(-no-framework)
		fi
	fi

	conf+=(
		# module-specific options
		"${myconf[@]}"
	)

	einfo "Configuring with: ${conf[@]}"
	"${S}"/configure "${conf[@]}" || die "configure failed"

	# configure is stupid and assigns QMAKE_LFLAGS twice,
	# thus the previous -rpath-link flag gets overwritten
	# and some packages (e.g. qthelp) fail to link
	sed -i -e '/^QMAKE_LFLAGS =/ s:$: $$QMAKE_LFLAGS:' \
		.qmake.cache || die "sed .qmake.cache failed"

	qt4_qmake
	qt4_foreach_target_subdir qt4_qmake
}

qt4_multilib_src_compile() {
	qt4_prepare_env

	qt4_foreach_target_subdir emake
}

qt4_multilib_src_test() {
	qt4_prepare_env

	qt4_foreach_target_subdir emake -j1 check
}

qt4_multilib_src_install() {
	qt4_prepare_env

	qt4_foreach_target_subdir emake INSTALL_ROOT="${D}" install

	if [[ ${PN} == qtcore ]]; then
		set -- emake INSTALL_ROOT="${D}" install_{mkspecs,qmake}
		einfo "Running $*"
		"$@"

		# install env.d file
		cat > "${T}/44qt4-${CHOST}" <<-_EOF_
			LDPATH="${QT4_LIBDIR}"
		_EOF_
		doenvd "${T}/44qt4-${CHOST}"

		# install qtchooser configuration file
		cat > "${T}/qt4-${CHOST}.conf" <<-_EOF_
			${QT4_BINDIR}
			${QT4_LIBDIR}
		_EOF_

		(
			insinto /etc/xdg/qtchooser
			doins "${T}/qt4-${CHOST}.conf"
		)

		if multilib_is_native_abi; then
			# convenience symlinks
			dosym qt4-"${CHOST}".conf /etc/xdg/qtchooser/4.conf
			dosym qt4-"${CHOST}".conf /etc/xdg/qtchooser/qt4.conf
			# TODO bug 522646: write an eselect module to manage default.conf
			dosym qt4.conf /etc/xdg/qtchooser/default.conf
		fi
	fi

	# move pkgconfig directory to the correct location
	if [[ -d ${D}${QT4_LIBDIR}/pkgconfig ]]; then
		mv "${D}${QT4_LIBDIR}"/pkgconfig "${ED}usr/$(get_libdir)" || die
	fi

	qt4_install_module_qconfigs
	qt4_symlink_framework_headers
}

qt4_multilib_src_install_all() {
	if [[ ${PN} == qtcore ]]; then
		# include gentoo-qconfig.h at the beginning of Qt{,Core}/qconfig.h
		if use aqua && [[ ${CHOST#*-darwin} -ge 9 ]]; then
			sed -i -e '1i #include <QtCore/Gentoo/gentoo-qconfig.h>\n' \
				"${D}${QT4_LIBDIR}"/QtCore.framework/Headers/qconfig.h \
				|| die "sed failed (qconfig.h)"
			dosym "${QT4_HEADERDIR#${EPREFIX}}"/Gentoo \
				"${QT4_LIBDIR#${EPREFIX}}"/QtCore.framework/Headers/Gentoo
		else
			sed -i -e '1i #include <Gentoo/gentoo-qconfig.h>\n' \
				"${D}${QT4_HEADERDIR}"/Qt{,Core}/qconfig.h \
				|| die "sed failed (qconfig.h)"
		fi

		dodir "${QT4_DATADIR#${EPREFIX}}"/mkspecs/gentoo
		mv "${D}${QT4_DATADIR}"/mkspecs/{qconfig.pri,gentoo/} || die
	fi

	# install private headers of a few modules
	if has ${PN} qtcore qtdeclarative qtgui qtscript; then
		local moduledir=${PN#qt}
		local modulename=Qt$(tr 'a-z' 'A-Z' <<< ${moduledir:0:1})${moduledir:1}
		[[ ${moduledir} == core ]] && moduledir=corelib

		einfo "Installing private headers into ${QT4_HEADERDIR}/${modulename}/private"
		insinto "${QT4_HEADERDIR#${EPREFIX}}"/${modulename}/private
		find "${S}"/src/${moduledir} -type f -name '*_p.h' -exec doins '{}' + || die
	fi

	prune_libtool_files
}

# @FUNCTION: qt4-build-multilib_pkg_postinst
# @DESCRIPTION:
# Regenerate configuration after installation or upgrade/downgrade.
qt4-build-multilib_pkg_postinst() {
	qt4_regenerate_global_qconfigs
}

# @FUNCTION: qt4-build-multilib_pkg_postrm
# @DESCRIPTION:
# Regenerate configuration when a module is completely removed.
qt4-build-multilib_pkg_postrm() {
	qt4_regenerate_global_qconfigs
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

# @FUNCTION: qt_native_use
# @USAGE: <flag> [feature] [enableval]
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
#
# Outputs "-${enableval}-${feature}" if <flag> is enabled and we are currently
# building for the native ABI, "-no-${feature}" otherwise. If [feature] is not
# specified, <flag> is used in its place. If [enableval] is not specified,
# the "-${enableval}" prefix is omitted.
qt_native_use() {
	[[ $# -ge 1 ]] || die "${FUNCNAME}() requires at least one argument"

	multilib_is_native_abi && qt_use "$@" || echo "-no-${2:-$1}"
}


######  Internal functions  ######

# @FUNCTION: qt4_prepare_env
# @INTERNAL
# @DESCRIPTION:
# Prepares the environment for building Qt.
qt4_prepare_env() {
	# setup installation directories
	# note: keep paths in sync with qmake-utils.eclass
	QT4_PREFIX=${EPREFIX}/usr
	QT4_HEADERDIR=${QT4_PREFIX}/include/qt4
	QT4_LIBDIR=${QT4_PREFIX}/$(get_libdir)/qt4
	QT4_BINDIR=${QT4_LIBDIR}/bin
	QT4_PLUGINDIR=${QT4_LIBDIR}/plugins
	QT4_IMPORTDIR=${QT4_LIBDIR}/imports
	QT4_DATADIR=${QT4_PREFIX}/share/qt4
	QT4_DOCDIR=${QT4_PREFIX}/share/doc/qt-${PV}
	QT4_TRANSLATIONDIR=${QT4_DATADIR}/translations
	QT4_EXAMPLESDIR=${QT4_DATADIR}/examples
	QT4_DEMOSDIR=${QT4_DATADIR}/demos
	QT4_SYSCONFDIR=${EPREFIX}/etc/qt4
	QMAKE_LIBDIR_QT=${QT4_LIBDIR}

	export XDG_CONFIG_HOME="${T}"
}

# @FUNCTION: qt4_foreach_target_subdir
# @INTERNAL
# @DESCRIPTION:
# Executes the given command inside each directory listed in QT4_TARGET_DIRECTORIES.
qt4_foreach_target_subdir() {
	local ret=0 subdir=
	for subdir in ${QT4_TARGET_DIRECTORIES}; do
		mkdir -p "${subdir}" || die
		pushd "${subdir}" >/dev/null || die

		einfo "Running $* ${subdir:+in ${subdir}}"
		"$@"
		((ret+=$?))

		popd >/dev/null || die
	done

	return ${ret}
}

# @FUNCTION: qt4_symlink_tools_to_build_dir
# @INTERNAL
# @DESCRIPTION:
# Symlinks qtcore tools to BUILD_DIR,
# so that they can be used when building other modules.
qt4_symlink_tools_to_build_dir() {
	local tool= tools=()
	if [[ ${PN} != qtcore ]]; then
		tools+=(qmake moc rcc uic)
	fi

	mkdir -p "${BUILD_DIR}"/bin || die
	pushd "${BUILD_DIR}"/bin >/dev/null || die

	for tool in "${tools[@]}"; do
		[[ -e ${QT4_BINDIR}/${tool} ]] || continue
		ln -s "${QT4_BINDIR}/${tool}" . || die "failed to symlink ${tool}"
	done

	popd >/dev/null || die
}

# @FUNCTION: qt4_qmake
# @INTERNAL
# @DESCRIPTION:
# Helper function that runs qmake in the current target subdir.
# Intended to be called by qt4_foreach_target_subdir().
qt4_qmake() {
	local projectdir=${PWD/#${BUILD_DIR}/${S}}

	"${BUILD_DIR}"/bin/qmake \
		"${projectdir}" \
		CONFIG+=nostrip \
		LIBS+=-L"${QT4_LIBDIR}" \
		"${myqmakeargs[@]}" \
		|| die "qmake failed (${projectdir#${S}/})"
}

# @FUNCTION: qt4_install_module_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Creates and installs gentoo-specific ${PN}-qconfig.{h,pri} files.
qt4_install_module_qconfigs() {
	local x
	if [[ -n ${QCONFIG_ADD} || -n ${QCONFIG_REMOVE} ]]; then
		for x in QCONFIG_ADD QCONFIG_REMOVE; do
			[[ -n ${!x} ]] && echo ${x}=${!x} >> "${BUILD_DIR}"/${PN}-qconfig.pri
		done
		insinto ${QT4_DATADIR#${EPREFIX}}/mkspecs/gentoo
		doins "${BUILD_DIR}"/${PN}-qconfig.pri
	fi

	if [[ -n ${QCONFIG_DEFINE} ]]; then
		for x in ${QCONFIG_DEFINE}; do
			echo "#define ${x}" >> "${BUILD_DIR}"/gentoo-${PN}-qconfig.h
		done
		insinto ${QT4_HEADERDIR#${EPREFIX}}/Gentoo
		doins "${BUILD_DIR}"/gentoo-${PN}-qconfig.h
	fi
}

# @FUNCTION: qt4_regenerate_global_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Generates Gentoo-specific qconfig.{h,pri} according to the build configuration.
# Don't call die here because dying in pkg_post{inst,rm} only makes things worse.
qt4_regenerate_global_qconfigs() {
	if [[ -n ${QCONFIG_ADD} || -n ${QCONFIG_REMOVE} || -n ${QCONFIG_DEFINE} || ${PN} == qtcore ]]; then
		local x qconfig_add qconfig_remove qconfig_new
		for x in "${ROOT}${QT4_DATADIR}"/mkspecs/gentoo/*-qconfig.pri; do
			[[ -f ${x} ]] || continue
			qconfig_add+=" $(sed -n 's/^QCONFIG_ADD=//p' "${x}")"
			qconfig_remove+=" $(sed -n 's/^QCONFIG_REMOVE=//p' "${x}")"
		done

		if [[ -e "${ROOT}${QT4_DATADIR}"/mkspecs/gentoo/qconfig.pri ]]; then
			# start with the qconfig.pri that qtcore installed
			if ! cp "${ROOT}${QT4_DATADIR}"/mkspecs/gentoo/qconfig.pri \
				"${ROOT}${QT4_DATADIR}"/mkspecs/qconfig.pri; then
				eerror "cp qconfig failed."
				return 1
			fi

			# generate list of QT_CONFIG entries from the existing list
			# including qconfig_add and excluding qconfig_remove
			for x in $(sed -n 's/^QT_CONFIG +=//p' \
				"${ROOT}${QT4_DATADIR}"/mkspecs/qconfig.pri) ${qconfig_add}; do
					has ${x} ${qconfig_remove} || qconfig_new+=" ${x}"
			done

			# replace the existing QT_CONFIG list with qconfig_new
			if ! sed -i -e "s/QT_CONFIG +=.*/QT_CONFIG += ${qconfig_new}/" \
				"${ROOT}${QT4_DATADIR}"/mkspecs/qconfig.pri; then
				eerror "Sed for QT_CONFIG failed"
				return 1
			fi

			# create Gentoo/qconfig.h
			if [[ ! -e ${ROOT}${QT4_HEADERDIR}/Gentoo ]]; then
				if ! mkdir -p "${ROOT}${QT4_HEADERDIR}"/Gentoo; then
					eerror "mkdir ${QT4_HEADERDIR}/Gentoo failed"
					return 1
				fi
			fi
			: > "${ROOT}${QT4_HEADERDIR}"/Gentoo/gentoo-qconfig.h
			for x in "${ROOT}${QT4_HEADERDIR}"/Gentoo/gentoo-*-qconfig.h; do
				[[ -f ${x} ]] || continue
				cat "${x}" >> "${ROOT}${QT4_HEADERDIR}"/Gentoo/gentoo-qconfig.h
			done
		else
			rm -f "${ROOT}${QT4_DATADIR}"/mkspecs/qconfig.pri
			rm -f "${ROOT}${QT4_HEADERDIR}"/Gentoo/gentoo-qconfig.h
			rmdir "${ROOT}${QT4_DATADIR}"/mkspecs \
				"${ROOT}${QT4_DATADIR}" \
				"${ROOT}${QT4_HEADERDIR}"/Gentoo \
				"${ROOT}${QT4_HEADERDIR}" 2>/dev/null
		fi
	fi
}

# @FUNCTION: qt4_symlink_framework_headers
# @DESCRIPTION:
# On OS X we need to add some symlinks when frameworks are being
# used, to avoid complications with some more or less stupid packages.
qt4_symlink_framework_headers() {
	if use_if_iuse aqua && [[ ${CHOST##*-darwin} -ge 9 ]]; then
		local frw dest f h rdir
		# Some packages tend to include <Qt/...>
		dodir "${QT4_HEADERDIR#${EPREFIX}}"/Qt

		# Fake normal headers when frameworks are installed... eases life later
		# on, make sure we use relative links though, as some ebuilds assume
		# these dirs exist in src_install to add additional files
		f=${QT4_HEADERDIR}
		h=${QT4_LIBDIR}
		while [[ -n ${f} && ${f%%/*} == ${h%%/*} ]] ; do
			f=${f#*/}
			h=${h#*/}
		done
		rdir=${h}
		f="../"
		while [[ ${h} == */* ]] ; do
			f="${f}../"
			h=${h#*/}
		done
		rdir="${f}${rdir}"

		for frw in "${D}${QT4_LIBDIR}"/*.framework; do
			[[ -e "${frw}"/Headers ]] || continue
			f=$(basename ${frw})
			dest="${QT4_HEADERDIR#${EPREFIX}}"/${f%.framework}
			dosym "${rdir}"/${f}/Headers "${dest}"

			# Link normal headers as well.
			for hdr in "${D}${QT4_LIBDIR}/${f}"/Headers/*; do
				h=$(basename ${hdr})
				dosym "../${rdir}"/${f}/Headers/${h} \
					"${QT4_HEADERDIR#${EPREFIX}}"/Qt/${h}
			done
		done
	fi
}

# @FUNCTION: qt4_get_mkspec
# @INTERNAL
# @DESCRIPTION:
# Returns the right mkspec for the current CHOST/CXX combination.
qt4_get_mkspec() {
	local spec=

	case ${CHOST} in
		*-linux*)
			spec=linux ;;
		*-darwin*)
			use_if_iuse aqua &&
				spec=macx ||   # mac with carbon/cocoa
				spec=darwin ;; # darwin/mac with X11
		*-freebsd*|*-dragonfly*)
			spec=freebsd ;;
		*-netbsd*)
			spec=netbsd ;;
		*-openbsd*)
			spec=openbsd ;;
		*-aix*)
			spec=aix ;;
		hppa*-hpux*)
			spec=hpux ;;
		ia64*-hpux*)
			spec=hpuxi ;;
		*-solaris*)
			spec=solaris ;;
		*)
			die "qt4-build-multilib.eclass: unsupported CHOST '${CHOST}'" ;;
	esac

	case $(tc-getCXX) in
		*g++*)
			spec+=-g++ ;;
		*clang*)
			if [[ -d ${S}/mkspecs/unsupported/${spec}-clang ]]; then
				spec=unsupported/${spec}-clang
			else
				ewarn "${spec}-clang mkspec does not exist, falling back to ${spec}-g++"
				spec+=-g++
			fi ;;
		*icpc*)
			if [[ -d ${S}/mkspecs/${spec}-icc ]]; then
				spec+=-icc
			else
				ewarn "${spec}-icc mkspec does not exist, falling back to ${spec}-g++"
				spec+=-g++
			fi ;;
		*)
			die "qt4-build-multilib.eclass: unsupported compiler '$(tc-getCXX)'" ;;
	esac

	# Add -64 for 64-bit prefix profiles
	if use amd64-linux || use ia64-linux || use ppc64-linux ||
		use x64-macos ||
		use sparc64-freebsd || use x64-freebsd || use x64-openbsd ||
		use ia64-hpux ||
		use sparc64-solaris || use x64-solaris
	then
		[[ -d ${S}/mkspecs/${spec}-64 ]] && spec+=-64
	fi

	echo ${spec}
}
