# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# Authors: George Shapovalov <george@gentoo.org>
#          Steve Arnold <nerdboy@gentoo.org>
#
# Belongs to: ada herd <ada@gentoo.org>
#
# Notes:
#  HOMEPAGE and LICENSE are set in appropriate ebuild, as
#  gnat is developed by FSF and AdaCore "in parallel"
#
# The following vars can be set in ebuild before inheriting this eclass. They
# will be respected:
#  SLOT
#  BOOT_SLOT - where old bootstrap is used as it works fine

#WANT_AUTOMAKE="1.8"
#WANT_AUTOCONF="2.1"

inherit eutils versionator toolchain-funcs flag-o-matic multilib autotools \
	libtool fixheadtails gnuconfig pax-utils

EXPORT_FUNCTIONS pkg_setup pkg_postinst pkg_postrm src_unpack src_compile src_install

IUSE="nls"
# multilib is supported via profiles now, multilib usevar is deprecated

DEPEND=">=app-eselect/eselect-gnat-1.3
	sys-devel/bc
"

RDEPEND="app-eselect/eselect-gnat"

# Note!
# It may not be safe to source this at top level. Only source inside local
# functions!
GnatCommon="/usr/share/gnat/lib/gnat-common.bash"

#---->> globals and SLOT <<----

# just a check, this location seems to vary too much, easier to track it in
# ebuild
#[ -z "${GNATSOURCE}" ] && die "please set GNATSOURCE in ebuild! (before inherit)"

# versioning
# because of gnatpro/gnatgpl we need to track both gcc and gnat versions

# these simply default to $PV
GNATMAJOR=$(get_version_component_range 1)
GNATMINOR=$(get_version_component_range 2)
GNATBRANCH=$(get_version_component_range 1-2)
GNATRELEASE=$(get_version_component_range 1-3)
# this one is for the gnat-gpl which is versioned by gcc backend and ACT version
# number added on top
ACT_Ver=$(get_version_component_range 4)

# GCCVER and SLOT logic
#
# I better define vars for package names, as there was discussion on proper
# naming and it may change
PN_GnatGCC="gnat-gcc"
PN_GnatGpl="gnat-gpl"

# ATTN! GCCVER stands for the provided backend gcc, not the one on the system
# so tc-* functions are of no use here. The present versioning scheme makes
# GCCVER basically a part of PV, but *this may change*!!
#
# GCCVER can be set in the ebuild.
[[ -z ${GCCVER} ]] && GCCVER="${GNATRELEASE}"


# finally extract GCC version strings
GCCMAJOR=$(get_version_component_range 1 "${GCCVER}")
GCCMINOR=$(get_version_component_range 2 "${GCCVER}")
GCCBRANCH=$(get_version_component_range 1-2 "${GCCVER}")
GCCRELEASE=$(get_version_component_range 1-3 "${GCCVER}")

# SLOT logic, make it represent gcc backend, as this is what matters most
# There are some special cases, so we allow it to be defined in the ebuild
# ATTN!! If you set SLOT in the ebuild, don't forget to make sure that
# BOOT_SLOT is also set properly!
[[ -z ${SLOT} ]] && SLOT="${GCCBRANCH}"

# possible future crosscompilation support
export CTARGET=${CTARGET:-${CHOST}}

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

# Bootstrap CTARGET and SLOT logic. For now BOOT_TARGET=CHOST is "guaranteed" by
# profiles, so mostly watch out for the right SLOT used in the bootstrap.
# As above, with SLOT, it may need to be defined in the ebuild
BOOT_TARGET=${CTARGET}
[[ -z ${BOOT_SLOT} ]] && BOOT_SLOT=${SLOT}

# set our install locations
PREFIX=${GNATBUILD_PREFIX:-/usr} # not sure we need this hook, but may be..
LIBPATH=${PREFIX}/$(get_libdir)/${PN}/${CTARGET}/${SLOT}
LIBEXECPATH=${PREFIX}/libexec/${PN}/${CTARGET}/${SLOT}
INCLUDEPATH=${LIBPATH}/include
BINPATH=${PREFIX}/${CTARGET}/${PN}-bin/${SLOT}
DATAPATH=${PREFIX}/share/${PN}-data/${CTARGET}/${SLOT}
# ATTN! the one below should match the path defined in eselect-gnat module
CONFIG_PATH="/usr/share/gnat/eselect"
gnat_profile="${CTARGET}-${PN}-${SLOT}"
gnat_config_file="${CONFIG_PATH}/${gnat_profile}"


# ebuild globals
if [[ ${PN} == "${PN_GnatPro}" ]] && [[ ${GNATMAJOR} == "3" ]]; then
		DEPEND="x86? ( >=app-shells/tcsh-6.0 )"
fi
S="${WORKDIR}/gcc-${GCCVER}"

# bootstrap globals, common to src_unpack and src_compile
GNATBOOT="${WORKDIR}/usr"
GNATBUILD="${WORKDIR}/build"

# necessary for detecting lib locations and creating env.d entry
#XGCC="${GNATBUILD}/gcc/xgcc -B${GNATBUILD}/gcc"

#----<< globals and SLOT >>----

# set SRC_URI's in ebuilds for now

#----<< support checks >>----
# skipping this section - do not care about hardened/multilib for now

#---->> specs + env.d logic <<----
# TODO!!!
# set MANPATH, etc..
#----<< specs + env.d logic >>----


#---->> some helper functions <<----
is_multilib() {
	[[ ${GCCMAJOR} < 3 ]] && return 1
	case ${CTARGET} in
		mips64*|powerpc64*|s390x*|sparc64*|x86_64*)
			has_multilib_profile || use multilib ;;
		*)  false ;;
	esac
}

# adapted from toolchain,
# left only basic multilib functionality and cut off mips stuff

create_specs_file() {
	einfo "Creating a vanilla gcc specs file"
	"${WORKDIR}"/build/gcc/xgcc -dumpspecs > "${WORKDIR}"/build/vanilla.specs
}


# eselect stuff taken straight from toolchain.eclass and greatly simplified
add_profile_eselect_conf() {
	local gnat_config_file=$1
	local abi=$2
	local var

	echo >> "${D}/${gnat_config_file}"
	if ! is_multilib ; then
		echo "  ctarget=${CTARGET}" >> "${D}/${gnat_config_file}"
	else
		echo "[${abi}]" >> "${D}/${gnat_config_file}"
		var="CTARGET_${abi}"
		if [[ -n ${!var} ]] ; then
			echo "  ctarget=${!var}" >> "${D}/${gnat_config_file}"
		else
			var="CHOST_${abi}"
			if [[ -n ${!var} ]] ; then
				echo "  ctarget=${!var}" >> "${D}/${gnat_config_file}"
			else
				echo "  ctarget=${CTARGET}" >> "${D}/${gnat_config_file}"
			fi
		fi
	fi

	var="CFLAGS_${abi}"
	if [[ -n ${!var} ]] ; then
		echo "  cflags=${!var}" >> "${D}/${gnat_config_file}"
	fi
}


create_eselect_conf() {
	local abi

	dodir ${CONFIG_PATH}

	echo "[global]" > "${D}/${gnat_config_file}"
	echo "  version=${CTARGET}-${SLOT}" >> "${D}/${gnat_config_file}"
	echo "  binpath=${BINPATH}" >> "${D}/${gnat_config_file}"
	echo "  libexecpath=${LIBEXECPATH}" >> "${D}/${gnat_config_file}"
	echo "  ldpath=${LIBPATH}" >> "${D}/${gnat_config_file}"
	echo "  manpath=${DATAPATH}/man" >> "${D}/${gnat_config_file}"
	echo "  infopath=${DATAPATH}/info" >> "${D}/${gnat_config_file}"
	echo "  bin_prefix=${CTARGET}" >> "${D}/${gnat_config_file}"

	for abi in $(get_all_abis) ; do
		add_profile_eselect_conf "${D}/${gnat_config_file}" "${abi}"
	done
}



should_we_eselect_gnat() {
	# we only want to switch compilers if installing to / or /tmp/stage1root
	[[ ${ROOT} == "/" ]] || return 1

	# if the current config is invalid, we definitely want a new one
	# Note: due to bash quirkiness, the following must not be 1 line
	local curr_config
	curr_config=$(eselect gnat show | grep ${CTARGET} | awk '{ print $1 }') || return 0
	[[ -z ${curr_config} ]] && return 0

	# The logic is basically "try to keep the same profile if possible"

	if [[ ${curr_config} == ${CTARGET}-${PN}-${SLOT} ]] ; then
		return 0
	else
		elog "The current gcc config appears valid, so it will not be"
		elog "automatically switched for you.  If you would like to"
		elog "switch to the newly installed gcc version, do the"
		elog "following:"
		echo
		elog "eselect gnat set <profile>"
		echo
		ebeep
		return 1
	fi
}

# active compiler selection, called from pkg_postinst
do_gnat_config() {
	eselect gnat set ${CTARGET}-${PN}-${SLOT} &> /dev/null

	elog "The following gnat profile has been activated:"
	elog "${CTARGET}-${PN}-${SLOT}"
	elog ""
	elog "The compiler has been installed as gnatgcc, and the coverage testing"
	elog "tool as gnatgcov."
	elog ""
	elog "Ada handling in Gentoo allows you to have multiple gnat variants"
	elog "installed in parallel and automatically manage Ada libs."
	elog "Please take a look at the Ada project page for some documentation:"
	elog "http://www.gentoo.org/proj/en/prog_lang/ada/index.xml"
}


# Taken straight from the toolchain.eclass. Only removed the "obsolete hunk"
#
# The purpose of this DISGUSTING gcc multilib hack is to allow 64bit libs
# to live in lib instead of lib64 where they belong, with 32bit libraries
# in lib32. This hack has been around since the beginning of the amd64 port,
# and we're only now starting to fix everything that's broken. Eventually
# this should go away.
#
# Travis Tilley <lv@gentoo.org> (03 Sep 2004)
#
disgusting_gcc_multilib_HACK() {
	local config
	local libdirs
	if has_multilib_profile ; then
		case $(tc-arch) in
			amd64)
				config="i386/t-linux64"
				libdirs="../$(get_abi_LIBDIR amd64) ../$(get_abi_LIBDIR x86)" \
			;;
			ppc64)
				config="rs6000/t-linux64"
				libdirs="../$(get_abi_LIBDIR ppc64) ../$(get_abi_LIBDIR ppc)" \
			;;
		esac
	else
		die "Your profile is no longer supported by portage."
	fi

	einfo "updating multilib directories to be: ${libdirs}"
	sed -i -e "s:^MULTILIB_OSDIRNAMES.*:MULTILIB_OSDIRNAMES = ${libdirs}:" "${S}"/gcc/config/${config}
}


#---->> pkg_* <<----
gnatbuild_pkg_setup() {
	debug-print-function ${FUNCNAME} $@

	# Setup variables which would normally be in the profile
	if is_crosscompile ; then
		multilib_env ${CTARGET}
	fi

	# we dont want to use the installed compiler's specs to build gnat!
	unset GCC_SPECS
}

gnatbuild_pkg_postinst() {
	if should_we_eselect_gnat; then
		do_gnat_config
	else
		eselect gnat update
	fi

	# if primary compiler list is empty, add this profile to the list, so
	# that users are not left without active compilers (making sure that
	# libs are getting built for at least one)
	elog
	. ${GnatCommon} || die "failed to source common code"
	if [[ ! -f ${PRIMELIST} ]] || [[ ! -s ${PRIMELIST} ]]; then
		mkdir -p ${SETTINGSDIR}
		echo "${gnat_profile}" > ${PRIMELIST}
		elog "The list of primary compilers was empty and got assigned ${gnat_profile}."
	fi
	elog "Please edit ${PRIMELIST} and list there gnat profiles intended"
	elog "for common use, one per line."
}


gnatbuild_pkg_postrm() {
	# "eselect gnat update" now removes the env.d file if the corresponding
	# gnat profile was unmerged
	eselect gnat update
	elog "If you just unmerged the last gnat in this SLOT, your active gnat"
	elog "profile got unset. Please check what eselect gnat show tells you"
	elog "and set the desired profile"
}
#---->> pkg_* <<----

#---->> src_* <<----

# common unpack stuff
gnatbuild_src_unpack() {
	debug-print-function ${FUNCNAME} $@
	[ -z "$1" ] &&  gnatbuild_src_unpack all

	while [ "$1" ]; do
	case $1 in
		base_unpack)
			unpack ${A}
			pax-mark E $(find ${GNATBOOT} -name gnat1)

			cd "${S}"
			# patching gcc sources, following the toolchain
			# first, the common patches
			if [[ -d "${FILESDIR}"/patches ]] && [[ ! -z $(ls "${FILESDIR}"/patches/*.patch 2>/dev/null) ]] ; then
				EPATCH_MULTI_MSG="Applying common Gentoo patches ..." \
				epatch "${FILESDIR}"/patches/*.patch
			fi
			#
			# then per SLOT
			if [[ -d "${FILESDIR}"/patches/${SLOT} ]] && [[ ! -z $(ls "${FILESDIR}"/patches/${SLOT}/*.patch 2>/dev/null) ]] ; then
				EPATCH_MULTI_MSG="Applying SLOT-specific Gentoo patches ..." \
				epatch "${FILESDIR}"/patches/${SLOT}/*.patch
			fi
			# Replacing obsolete head/tail with POSIX compliant ones
			ht_fix_file */configure

#			if ! is_crosscompile && is_multilib && \
#				[[ ( $(tc-arch) == "amd64" || $(tc-arch) == "ppc64" ) && -z ${SKIP_MULTILIB_HACK} ]] ; then
#					disgusting_gcc_multilib_HACK || die "multilib hack failed"
#			fi

			# Fixup libtool to correctly generate .la files with portage
			cd "${S}"
			elibtoolize --portage --shallow --no-uclibc

			gnuconfig_update
			# update configure files
			einfo "Fixing misc issues in configure files"
			for f in $(grep -l 'autoconf version 2.13' $(find "${S}" -name configure)) ; do
				ebegin "  Updating ${f}"
				patch "${f}" "${FILESDIR}"/gcc-configure-LANG.patch >& "${T}"/configure-patch.log \
					|| eerror "Please file a bug about this"
				eend $?
			done

#			this is only needed for gnat-gpl-4.1 and breaks for gnat-gcc, so
#			this block was moved to corresponding ebuild
#			pushd "${S}"/gnattools &> /dev/null
#				eautoconf
#			popd &> /dev/null
		;;

		common_prep)
			# Prepare the gcc source directory
			cd "${S}/gcc"
			touch cstamp-h.in
			touch ada/[es]info.h
			touch ada/nmake.ad[bs]
			# set the compiler name to gnatgcc
			for i in `find ada/ -name '*.ad[sb]'`; do \
				sed -i -e "s/\"gcc\"/\"gnatgcc\"/g" ${i}; \
			done
			# add -fPIC flag to shared libs for 3.4* backend
			if [ "3.4" == "${GCCBRANCH}" ] ; then
				cd ada
				epatch "${FILESDIR}"/gnat-Make-lang.in.patch
			fi

			# gcc 4.3 sources seem to have a common omission of $(DESTDIR),
			# that leads to make install trying to rm -f file on live system.
			# As we do not need this rm, we simply remove the whole line
			if [ "4.3" == "${GCCBRANCH}" ] ; then
				sed -i -e "/\$(RM) \$(bindir)/d" "${S}"/gcc/ada/Make-lang.in
			fi

			mkdir -p "${GNATBUILD}"
		;;

		all)
			gnatbuild_src_unpack base_unpack common_prep
		;;
	esac
	shift
	done
}

# it would be nice to split configure and make steps
# but both need to operate inside specially tuned evironment
# so just do sections for now (as in eclass section of handbook)
# sections are: configure, make-tools, bootstrap,
#  gnatlib_and_tools, gnatlib-shared
gnatbuild_src_compile() {
	debug-print-function ${FUNCNAME} $@
	if [[ -z "$1" ]]; then
		gnatbuild_src_compile all
		return $?
	fi

	if [[ "all" == "$1" ]]
	then # specialcasing "all" to avoid scanning sources unnecessarily
		gnatbuild_src_compile configure make-tools \
			bootstrap gnatlib_and_tools gnatlib-shared

	else
		# Set some paths to our bootstrap compiler.
		export PATH="${GNATBOOT}/bin:${PATH}"
		# !ATTN! the bootstrap compilers have a very simplystic structure,
		# so many paths are not identical to the installed ones.
		# Plus it was simplified even more in new releases.
		if [[ ${BOOT_SLOT} > 4.1 ]] ; then
			GNATLIB="${GNATBOOT}/lib"
		else
			GNATLIB="${GNATBOOT}/lib/gnatgcc/${BOOT_TARGET}/${BOOT_SLOT}"
		fi

		export CC="${GNATBOOT}/bin/gnatgcc"
		# CPATH is supposed to be applied for any language, thus
		# superceding either of C/CPLUS/OBJC_INCLUDE_PATHs
		export CPATH="${GNATLIB}/include"
		#export INCLUDE_DIR="${GNATLIB}/include"
		#export C_INCLUDE_PATH="${GNATLIB}/include"
		#export CPLUS_INCLUDE_PATH="${GNATLIB}/include"
		export LIB_DIR="${GNATLIB}"
		export LDFLAGS="-L${GNATLIB}"

		# additional vars from gnuada and elsewhere
		#export LD_RUN_PATH="${LIBPATH}"
		export LIBRARY_PATH="${GNATLIB}"
		#export LD_LIBRARY_PATH="${GNATLIB}"
#		export COMPILER_PATH="${GNATBOOT}/bin/"

		export ADA_OBJECTS_PATH="${GNATLIB}/adalib"
		export ADA_INCLUDE_PATH="${GNATLIB}/adainclude"

#		einfo "CC=${CC},
#			ADA_INCLUDE_PATH=${ADA_INCLUDE_PATH},
#			LDFLAGS=${LDFLAGS},
#			PATH=${PATH}"

		while [ "$1" ]; do
		case $1 in
			configure)
				debug-print-section configure
				# Configure gcc
				local confgcc

				# some cross-compile logic from toolchain
				confgcc="${confgcc} --host=${CHOST}"
				if is_crosscompile || tc-is-cross-compiler ; then
					confgcc="${confgcc} --target=${CTARGET}"
				fi
				[[ -n ${CBUILD} ]] && confgcc="${confgcc} --build=${CBUILD}"

				# Native Language Support
				if use nls ; then
					confgcc="${confgcc} --enable-nls --without-included-gettext"
				else
					confgcc="${confgcc} --disable-nls"
				fi

				if version_is_at_least 4.6 ; then
					confgcc+=( $(use_enable lto) )
				else
					confgcc+=( --disable-lto )
				fi

				# reasonably sane globals (from toolchain)
				# also disable mudflap and ssp
				confgcc="${confgcc} \
					--with-system-zlib \
					--disable-checking \
					--disable-werror \
					--disable-libgomp \
					--disable-libmudflap \
					--disable-libssp \
					--disable-libunwind-exceptions"

				if in_iuse openmp ; then
					# Make sure target has pthreads support. #326757 #335883
					# There shouldn't be a chicken&egg problem here as openmp won't
					# build without a C library, and you can't build that w/out
					# already having a compiler ...
					if ! is_crosscompile || \
						$(tc-getCPP ${CTARGET}) -E - <<<"#include <pthread.h>" >& /dev/null
					then
						case $(tc-arch) in
							arm)
								confgcc+=( --disable-libgomp )
								;;
							*)
								confgcc+=( $(use_enable openmp libgomp) )
								;;
						esac
					else
						# Force disable as the configure script can be dumb #359855
						confgcc+=( --disable-libgomp )
					fi
				else
					# For gcc variants where we don't want openmp (e.g. kgcc)
					confgcc+=( --disable-libgomp )
				fi

				# ACT's gnat-gpl does not like libada for whatever reason..
				if version_is_at_least 4.2 ; then
					confgcc="${confgcc} --enable-libada"
#				else
#					einfo "ACT's gnat-gpl does not like libada, disabling"
#					confgcc="${confgcc} --disable-libada"
				fi

				# set some specifics available in later versions
				if version_is_at_least 4.3 ; then
					einfo "setting gnat thread model"
					confgcc="${confgcc} --enable-threads=gnat"
					confgcc="${confgcc} --enable-shared=boehm-gc,ada,libada"
				else
					confgcc="${confgcc} --enable-threads=posix"
					confgcc="${confgcc} --enable-shared"
				fi

				# multilib support
				if is_multilib ; then
					confgcc="${confgcc} --enable-multilib"
				else
					confgcc="${confgcc} --disable-multilib"
				fi

				# __cxa_atexit is "essential for fully standards-compliant handling of
				# destructors", but apparently requires glibc.
				if [[ ${CTARGET} == *-gnu* ]] ; then
					confgcc="${confgcc} --enable-__cxa_atexit"
					confgcc="${confgcc} --enable-clocale=gnu"
				fi

				einfo "confgcc=${confgcc}"

				# need to strip graphite flags or we'll get the
				# dreaded C compiler cannot create executables...
				# error.
				strip-flags -floop-interchange -floop-strip-mine -floop-block

				cd "${GNATBUILD}"
				CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" "${S}"/configure \
					--prefix=${PREFIX} \
					--bindir=${BINPATH} \
					--includedir=${INCLUDEPATH} \
					--libdir="${LIBPATH}" \
					--libexecdir="${LIBEXECPATH}" \
					--datadir=${DATAPATH} \
					--mandir=${DATAPATH}/man \
					--infodir=${DATAPATH}/info \
					--program-prefix=gnat \
					--enable-languages="c,ada" \
					--with-gcc \
					${confgcc} || die "configure failed"
			;;

			make-tools)
				debug-print-section make-tools
				# Compile helper tools
				cd "${GNATBOOT}"
				cp "${S}"/gcc/ada/xtreeprs.adb .
				cp "${S}"/gcc/ada/xsinfo.adb   .
				cp "${S}"/gcc/ada/xeinfo.adb   .
				cp "${S}"/gcc/ada/xnmake.adb   .
				cp "${S}"/gcc/ada/xutil.ad{s,b}   .
				if (( ${GNATMINOR} > 5 )) ; then
					cp "${S}"/gcc/ada/einfo.ad{s,b}  .
					cp "${S}"/gcc/ada/csinfo.adb  .
					cp "${S}"/gcc/ada/ceinfo.adb  .
				fi
				gnatmake xtreeprs && \
				gnatmake xsinfo   && \
				gnatmake xeinfo   && \
				gnatmake xnmake   || die "building helper tools"
			;;

			bootstrap)
				debug-print-section bootstrap
				# and, finally, the build itself
				cd "${GNATBUILD}"
				emake bootstrap || die "bootstrap failed"
			;;

			gnatlib_and_tools)
				debug-print-section gnatlib_and_tools
				einfo "building gnatlib_and_tools"
				cd "${GNATBUILD}"
				emake -j1 -C gcc gnatlib_and_tools || \
					die "gnatlib_and_tools failed"
			;;

			gnatlib-shared)
				debug-print-section gnatlib-shared
				einfo "building shared lib"
				cd "${GNATBUILD}"
				rm -f gcc/ada/rts/*.{o,ali} || die
				#otherwise make tries to reuse already compiled (without -fPIC) objs..
				emake -j1 -C gcc gnatlib-shared LIBRARY_VERSION="${GCCBRANCH}" || \
					die "gnatlib-shared failed"
			;;

		esac
		shift
		done # while
	fi   # "all" == "$1"
}
# -- end gnatbuild_src_compile


gnatbuild_src_install() {
	debug-print-function ${FUNCNAME} $@

	if [[ -z "$1" ]] ; then
		gnatbuild_src_install all
		return $?
	fi

	while [ "$1" ]; do
	case $1 in
	install) # runs provided make install
		debug-print-section install

		# Looks like we need an access to the bootstrap compiler here too
		# as gnat apparently wants to compile something during the installation
		# The spotted obuser was xgnatugn, used to process gnat_ugn_urw.texi,
		# during preparison of the docs.
		export PATH="${GNATBOOT}/bin:${PATH}"
		if [[ ${BOOT_SLOT} > 4.1 ]] ; then
			GNATLIB="${GNATBOOT}/lib"
		else
			GNATLIB="${GNATBOOT}/lib/gnatgcc/${BOOT_TARGET}/${BOOT_SLOT}"
		fi

		export CC="${GNATBOOT}/bin/gnatgcc"
		export INCLUDE_DIR="${GNATLIB}/include"
		export C_INCLUDE_PATH="${GNATLIB}/include"
		export CPLUS_INCLUDE_PATH="${GNATLIB}/include"
		export LIB_DIR="${GNATLIB}"
		export LDFLAGS="-L${GNATLIB}"
		export ADA_OBJECTS_PATH="${GNATLIB}/adalib"
		export ADA_INCLUDE_PATH="${GNATLIB}/adainclude"

		# Do not allow symlinks in /usr/lib/gcc/${CHOST}/${MY_PV}/include as
		# this can break the build.
		for x in "${GNATBUILD}"/gcc/include/* ; do
			if [ -L ${x} ] ; then
				rm -f ${x}
			fi
		done
		# Remove generated headers, as they can cause things to break
		# (ncurses, openssl, etc). (from toolchain.eclass)
		for x in $(find "${WORKDIR}"/build/gcc/include/ -name '*.h') ; do
			grep -q 'It has been auto-edited by fixincludes from' "${x}" \
				&& rm -f "${x}"
		done


		cd "${GNATBUILD}"
		make DESTDIR="${D}" install || die

		if use doc ; then
			if (( $(bc <<< "${GNATBRANCH} > 4.3") )) ; then
				#make a convenience info link
				elog "Yay!  Math is good."
				dosym gnat_ugn.info ${DATAPATH}/info/gnat.info
			fi
		fi
		;;

	move_libs)
		debug-print-section move_libs

		# first we need to remove some stuff to make moving easier
		rm -rf "${D}${LIBPATH}"/{32,include,libiberty.a}
		# gcc insists on installing libs in its own place
		mv "${D}${LIBPATH}/gcc/${CTARGET}/${GCCRELEASE}"/* "${D}${LIBPATH}"
		mv "${D}${LIBEXECPATH}/gcc/${CTARGET}/${GCCRELEASE}"/* "${D}${LIBEXECPATH}"

		# libgcc_s  and, with gcc>=4.0, other libs get installed in multilib specific locations by gcc
		# we pull everything together to simplify working environment
		if has_multilib_profile ; then
			case $(tc-arch) in
				amd64)
					mv "${D}${LIBPATH}"/../$(get_abi_LIBDIR amd64)/* "${D}${LIBPATH}"
					mv "${D}${LIBPATH}"/../$(get_abi_LIBDIR x86)/* "${D}${LIBPATH}"/32
				;;
				ppc64)
					# not supported yet, will have to be adjusted when we
					# actually build gnat for that arch
				;;
			esac
		fi

		# force gnatgcc to use its own specs - versions prior to 3.4.6 read specs
		# from system gcc location. Do the simple wrapper trick for now
		# !ATTN! change this if eselect-gnat starts to follow eselect-compiler
		if [[ ${GCCVER} < 3.4.6 ]] ; then
			# gcc 4.1 uses builtin specs. What about 4.0?
			cd "${D}${BINPATH}"
			mv gnatgcc gnatgcc_2wrap
			cat > gnatgcc << EOF
#! /bin/bash
# wrapper to cause gnatgcc read appropriate specs and search for the right .h
# files (in case no matching gcc is installed)
BINDIR=\$(dirname \$0)
# The paths in the next line have to be absolute, as gnatgcc may be called from
# any location
\${BINDIR}/gnatgcc_2wrap -specs="${LIBPATH}/specs" -I"${LIBPATH}/include" \$@
EOF
			chmod a+x gnatgcc
		fi

		# earlier gnat's generate some Makefile's at generic location, need to
		# move to avoid collisions
		[ -f "${D}${PREFIX}"/share/gnat/Makefile.generic ] &&
			mv "${D}${PREFIX}"/share/gnat/Makefile.* "${D}${DATAPATH}"

		# use gid of 0 because some stupid ports don't have
		# the group 'root' set to gid 0 (toolchain.eclass)
		chown -R root:0 "${D}${LIBPATH}"
		;;

	cleanup)
		debug-print-section cleanup

		rm -rf "${D}${LIBPATH}"/{gcc,install-tools,../lib{32,64}}
		rm -rf "${D}${LIBEXECPATH}"/{gcc,install-tools}

		# this one is installed by gcc and is a duplicate even here anyway
		rm -f "${D}${BINPATH}/${CTARGET}-gcc-${GCCRELEASE}"

		# remove duplicate docs
		rm -f  "${D}${DATAPATH}"/info/{dir,gcc,cpp}*
		rm -rf "${D}${DATAPATH}"/man/man7/

		# fix .la path for lto plugin
		if use lto ; then
			sed -i -e \
				"/libdir=/c\libdir='${LIBEXECPATH}'" \
				"${D}${LIBEXECPATH}"/liblto_plugin.la \
				|| die "sed update of .la file failed!"
		fi

		# add config directory (bug 440660)
		keepdir /etc/ada
		;;

	prep_env)
		# instead of putting junk under /etc/env.d/gnat we recreate env files as
		# needed with eselect
		create_eselect_conf
		;;

	all)
		gnatbuild_src_install install move_libs cleanup prep_env
		;;
	esac
	shift
	done # while
}
# -- end gnatbuild_src_install
