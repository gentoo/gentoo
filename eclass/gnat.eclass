# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# Author: George Shapovalov <george@gentoo.org>
# Belongs to: ada herd <ada@gentoo.org>
#
# This eclass provides the framework for ada lib installation with the split and
# SLOTted gnat compilers (gnat-xxx, gnatbuild.eclass). Each lib gets built once
# for every installed gnat compiler. Activation of a particular bunary module is
# performed by eselect-gnat, when the active compiler gets switched
#
# The ebuilds should define the lib_compile and lib_install functions that are
# called from the (exported) gnat_src_compile function of eclass. These
# functions should operate similarly to the starndard src_compile and
# src_install. The only difference, that they should use $SL variable instead of
# $S (this is where the working copy of source is held) and $DL instead of $D as
# its installation point.

inherit flag-o-matic eutils multilib

# The environment is set locally in src_compile and src_install functions
# by the common code sourced here and in gnat-eselect module.
# This is the standard location for this code (belongs to eselect-gnat,
# since eselect should work even in the absense of portage tree and we can
# guarantee to some extent presence of gnat-eselect when anything gnat-related
# gets processed. See #192505)
#
# Note!
# It may not be safe to source this at top level. Only source inside local
# functions!
GnatCommon="/usr/share/gnat/lib/gnat-common.bash"

# !!NOTE!!
# src_install should not be exported!
# Instead gnat_src_install should be explicitly called from within src_install.
EXPORT_FUNCTIONS pkg_setup pkg_postinst src_compile

DESCRIPTION="Common procedures for building Ada libs using split gnat compilers"

# make sure we have an appropriately recent eselect-gnat installed, as we are
# using some common code here.
DEPEND=">=app-eselect/eselect-gnat-1.3"


# ----------------------------------
# Globals

# Lib install locations
#
# Gnat profile dependent files go under ${LibTop}/${Gnat_Profile}/${PN}
# and common files go under SpecsDir, DataDir..
# In order not to pollute PATH and LDPATH attempt should be mabe to install
# binaries and what makes sence for individual packages under
# ${AdalibLibTop}/${Gnat_Profile}/bin
PREFIX=/usr
AdalibSpecsDir=${PREFIX}/include/ada
AdalibDataDir=${PREFIX}/share/ada
AdalibLibTop=${PREFIX}/$(get_libdir)/ada

# build-time locations
# SL is a "localized" S, - location where sources are copied for
#bi profile-specific build
SL=${WORKDIR}/LocalSource

# DL* are "localized destinations" where ARCH/SLOT dependent stuff should be
# installed in lib_install.   There are three:
#
DL=${WORKDIR}/LocalDest
#	a generic location for the lib (.a, .so) files
#
DLbin=${WORKDIR}/LocalBinDest
#	binaries that should be in the PATH, will be moved to common Ada bin dir
#
DLgpr=${WORKDIR}/LocalGPRDest
#	gpr's should go here.

# file containing environment formed by gnat-eselect (build-time)
BuildEnv=${WORKDIR}/BuildEnv

# environment for installed lib. Profile-specific stuff should use %DL% as a top
# of their location. This (%DL%) will be substituted with a proper location upon
# install
LibEnv=${WORKDIR}/LibEnv


# env file prepared by gnat.eselect only lists new settings for env vars
# we need to change that to prepend, rather than replace action..
# Takes one argument - the file to expand. This file should contain only
# var=value like lines.. (commenst are Ok)
expand_BuildEnv() {
	local line
	for line in $(cat $1); do
		EnvVar=$(echo ${line}|cut -d"=" -f1)
		if [[ "${EnvVar}" == "PATH" ]] ; then
			echo "export ${line}:\${${EnvVar}}" >> $1.tmp
		else
			echo "export ${line}" >> $1.tmp
		fi
	done
	mv $1.tmp $1
}


# ------------------------------------
# Dependency processing related stuff

# A simple wrapper to get the relevant part of the DEPEND
# params:
#  $1 - should contain dependency specification analogous to DEPEND,
#       if omitted, DEPEND is processed
get_ada_dep() {
	[[ -z "$1" ]] && DEP="${DEPEND}" || DEP="$1"
	local TempStr
	for fn in $DEP; do # here $DEP should *not* be in ""
		[[ $fn =~ "virtual/ada" ]] && TempStr=${fn/*virtual\//}
		# above match should be to full virtual/ada, as simply "ada" is a common
		# part of ${PN}, even for some packages under dev-ada
	done
#	debug-print-function $FUNCNAME "TempStr=${TempStr:0:8}"
	[[ -n ${TempStr} ]] && echo ${TempStr:0:8}
}

# This function is used to check whether the requested gnat profile matches the
# requested Ada standard
# !!ATTN!!
# This must match dependencies as specified in vitrual/ada !!!
#
# params:
#  $1 - the requested gnat profile in usual form (e.g. x86_64-pc-linux-gnu-gnat-gcc-4.1)
#  $2 - Ada standard specification, as would be specified in DEPEND.
#       Valid  values: ada-1995, ada-2005, ada
#
#       This used to treat ada-1995 and ada alike, but some packages (still
#       requested by users) no longer compile with new compilers (not the
#       standard issue, but rather compiler becoming stricter most of the time).
#       Plus there are some "intermediary versions", not fully 2005 compliant
#       but already causing problems.  Therefore, now we do exact matching.
belongs_to_standard() {
#	debug-print-function $FUNCNAME $*
	. ${GnatCommon} || die "failed to source gnat-common lib"
	local GnatSlot=$(get_gnat_SLOT $1)
	local ReducedSlot=${GnatSlot//\./}
	#
	if [[ $2 == 'ada' ]] ; then
#		debug-print-function "ada or ada-1995 match"
		return 0 # no restrictions imposed
	elif [[ "$2" == 'ada-1995' ]] ; then
		if [[ $(get_gnat_Pkg $1) == "gcc" ]]; then
#			debug-print-function "got gcc profile, GnatSlot=${ReducedSlot}"
			[[ ${ReducedSlot} -le "42" ]] && return 0 || return 1
		elif [[ $(get_gnat_Pkg $1) == "gpl" ]]; then
#			debug-print-function "got gpl profile, GnatSlot=${ReducedSlot}"
			[[ ${ReducedSlot} -lt "41" ]] && return 0 || return 1
		else
			return 1 # unknown compiler encountered
		fi
	elif [[ "$2" == 'ada-2005' ]] ; then
		if [[ $(get_gnat_Pkg $1) == "gcc" ]]; then
#			debug-print-function "got gcc profile, GnatSlot=${ReducedSlot}"
			[[ ${ReducedSlot} -ge "43" ]] && return 0 || return 1
		elif [[ $(get_gnat_Pkg $1) == "gpl" ]]; then
#			debug-print-function "got gpl profile, GnatSlot=${ReducedSlot}"
			[[ ${ReducedSlot} -ge "41" ]] && return 0 || return 1
		else
			return 1 # unknown compiler encountered
		fi
	else
		return 1 # unknown standard requested, check spelling!
	fi
}


# ------------------------------------
# Helpers
#


# The purpose of this one is to remove all parts of the env entry specific to a
# given lib. Usefull when some lib wants to act differently upon detecting
# itself installed..
#
# params:
#  $1 - name of env var to process
#  $2 (opt) - name of the lib to filter out (defaults to ${PN})
filter_env_var() {
	local entries=(${!1//:/ })
	local libName=${2:-${PN}}
	local env_str
	for entry in ${entries[@]} ; do
		# this simply checks if $libname is a substring of the $entry, should
		# work fine with all the present libs
		if [[ ${entry/${libName}/} == ${entry} ]] ; then
			env_str="${env_str}:${entry}"
		fi
	done
	echo ${env_str}
}

# A simpler helper, for the libs that need to extract active gnat location
# Returns a first entry for a specified env var. Relies on the (presently true)
# convention that first gnat's entries are listed and then of the other
# installed libs.
#
# params:
#  $1 - name of env var to process
get_gnat_value() {
	local entries=(${!1//:/ })
	echo ${entries[0]}
}


# Returns a name of active gnat profile. Performs some validity checks. No input
# parameters, analyzes the system setup directly.
get_active_profile() {
	# get common code and settings
	. ${GnatCommon} || die "failed to source gnat-common lib"

	local profiles=( $(get_env_list) )

	if [[ ${profiles[@]} == "${MARKER}*" ]]; then
		return
		# returning empty string
	fi

	if (( 1 == ${#profiles[@]} )); then
		local active=${profiles[0]#${MARKER}}
	else
		die "${ENVDIR} contains multiple gnat profiles, please cleanup!"
	fi

	if [[ -f ${SPECSDIR}/${active} ]]; then
		echo ${active}
	else
		die "The profile active in ${ENVDIR} does not correspond to any installed gnat!"
	fi
}



# ------------------------------------
# Functions

# Checks the gnat backend SLOT and filters flags correspondingly
# To be called from scr_compile for each profile, before actual compilation
# Parameters:
#  $1 - gnat profile, e.g. x86_64-pc-linux-gnu-gnat-gcc-3.4
gnat_filter_flags() {
	debug-print-function $FUNCNAME $*

	# We only need to filter so severely if backends < 3.4 is detected, which
	# means basically gnat-3.15
	GnatProfile=$1
	if [ -z ${GnatProfile} ]; then
		# should not get here!
		die "please specify a valid gnat profile for flag stripping!"
	fi

	local GnatSLOT="${GnatProfile//*-/}"
	if [[ ${GnatSLOT} < 3.4 ]] ; then
		filter-mfpmath sse 387

		filter-flags -mmmx -msse -mfpmath -frename-registers \
			-fprefetch-loop-arrays -falign-functions=4 -falign-jumps=4 \
			-falign-loops=4 -msse2 -frerun-loop-opt -maltivec -mabi=altivec \
			-fsigned-char -fno-strict-aliasing -pipe

		export ADACFLAGS=${ADACFLAGS:-${CFLAGS}}
		export ADACFLAGS=${ADACFLAGS//-Os/-O2}
		export ADACFLAGS=${ADACFLAGS//pentium-mmx/i586}
		export ADACFLAGS=${ADACFLAGS//pentium[234]/i686}
		export ADACFLAGS=${ADACFLAGS//k6-[23]/k6}
		export ADACFLAGS=${ADACFLAGS//athlon-tbird/i686}
		export ADACFLAGS=${ADACFLAGS//athlon-4/i686}
		export ADACFLAGS=${ADACFLAGS//athlon-[xm]p/i686}
		# gcc-2.8.1 has no amd64 support, so the following two are safe
		export ADACFLAGS=${ADACFLAGS//athlon64/i686}
		export ADACFLAGS=${ADACFLAGS//athlon/i686}
	else
		export ADACFLAGS=${ADACFLAGS:-${CFLAGS}}
	fi

	export ADAMAKEFLAGS=${ADAMAKEFLAGS:-"-cargs ${ADACFLAGS} -margs"}
	export ADABINDFLAGS=${ADABINDFLAGS:-""}
}

gnat_pkg_setup() {
	debug-print-function $FUNCNAME $*

	# check whether all the primary compilers are installed
	. ${GnatCommon} || die "failed to source gnat-common lib"
	for fn in $(cat ${PRIMELIST}); do
		if [[ ! -f ${SPECSDIR}/${fn} ]]; then
			elog "The ${fn} Ada compiler profile is specified as primary, but is not installed."
			elog "Please rectify the situation before emerging Ada library!"
			elog "Please either install again all the missing compilers listed"
			elog "as primary, or edit /etc/ada/primary_compilers and update the"
			elog "list of primary compilers there."
			einfo ""
			ewarn "If you do the latter, please don't forget to rebuild all"
			ewarn "affected libs!"
			die "Primary compiler is missing"
		fi
	done

	export ADAC=${ADAC:-gnatgcc}
	export ADAMAKE=${ADAMAKE:-gnatmake}
	export ADABIND=${ADABIND:-gnatbind}
}


gnat_pkg_postinst() {
	einfo "Updating gnat configuration to pick up ${PN} library..."
	eselect gnat update
	elog "The environment has been set up to make gnat automatically find files"
	elog "for the installed library. In order to immediately activate these"
	elog "settings please run:"
	elog
	#elog "env-update"
	elog "source /etc/profile"
	einfo
	einfo "Otherwise the settings will become active next time you login"
}




# standard lib_compile plug. Adapted from base.eclass
lib_compile() {
	debug-print-function $FUNCNAME $*
	[ -z "$1" ] && lib_compile all

	cd ${SL}

	while [ "$1" ]; do
	case $1 in
		configure)
			debug-print-section configure
			econf || die "died running econf, $FUNCNAME:configure"
		;;
		make)
			debug-print-section make
			emake || die "died running emake, $FUNCNAME:make"
		;;
		all)
			debug-print-section all
			lib_compile configure make
		;;
	esac
	shift
	done
}

# Cycles through installed gnat profiles and calls lib_compile and then
# lib_install in turn.
# Use this function to build/install profile-specific binaries. The code
# building/installing common stuff (docs, etc) can go before/after, as needed,
# so that it is called only once..
#
# lib_compile and lib_install are passed the active gnat profile name - may be used or
# discarded as needed..
gnat_src_compile() {
	debug-print-function $FUNCNAME $*

	# We source the eselect-gnat module and use its functions directly, instead of
	# duplicating code or trying to violate sandbox in some way..
	. ${GnatCommon} || die "failed to source gnat-common lib"

	compilers=( $(find_primary_compilers ) )
	if [[ -n ${compilers[@]} ]] ; then
		local i
		local AdaDep=$(get_ada_dep)
		for (( i = 0 ; i < ${#compilers[@]} ; i = i + 1 )) ; do
			if $(belongs_to_standard ${compilers[${i}]} ${AdaDep}); then
				einfo "compiling for gnat profile ${compilers[${i}]}"

				# copy sources
				mkdir "${DL}" "${DLbin}" "${DLgpr}"
				cp -dpR "${S}" "${SL}"

				# setup environment
				# As eselect-gnat also manages the libs, this will ensure the right
				# lib profiles are activated too (in case we depend on some Ada lib)
				generate_envFile ${compilers[${i}]} ${BuildEnv} && \
				expand_BuildEnv "${BuildEnv}" && \
				. "${BuildEnv}"  || die "failed to switch to ${compilers[${i}]}"
				# many libs (notably xmlada and gtkada) do not like to see
				# themselves installed. Need to strip them from ADA_*_PATH
				# NOTE: this should not be done in pkg_setup, as we setup
				# environment right above
				export ADA_INCLUDE_PATH=$(filter_env_var ADA_INCLUDE_PATH)
				export ADA_OBJECTS_PATH=$(filter_env_var ADA_OBJECTS_PATH)

				# call compilation callback
				cd "${SL}"
				gnat_filter_flags ${compilers[${i}]}
				lib_compile ${compilers[${i}]} || die "failed compiling for ${compilers[${i}]}"

				# call install callback
				cd "${SL}"
				lib_install ${compilers[${i}]} || die "failed installing profile-specific part for ${compilers[${i}]}"
				# move installed and cleanup
				mv "${DL}" "${DL}-${compilers[${i}]}"
				mv "${DLbin}" "${DLbin}-${compilers[${i}]}"
				mv "${DLgpr}" "${DLgpr}-${compilers[${i}]}"
				rm -rf "${SL}"
			else
				einfo "skipping gnat profile ${compilers[${i}]}"
			fi
		done
	else
		ewarn "Please note!"
		elog "Treatment of installed Ada compilers has recently changed!"
		elog "Libs are now being built only for \"primary\" compilers."
		elog "Please list gnat profiles (as reported by \"eselect gnat list\")"
		elog "that you want to regularly use (i.e., not just for testing)"
		elog "in ${PRIMELIST}, one per line."
		die "please make sure you have at least one gnat compiler installed and set as primary!"
	fi
}


# This function simply moves gnat-profile-specific stuff into proper locations.
# Use src_install in ebuild to install the rest of the package
gnat_src_install() {
	debug-print-function $FUNCNAME $*

	# prep lib specs directory
	. ${GnatCommon} || die "failed to source gnat-common lib"
	dodir ${SPECSDIR}/${PN}

	compilers=( $(find_primary_compilers) )
	if [[ -n ${compilers[@]} ]] ; then
		local i
		local AdaDep=$(get_ada_dep)
		for (( i = 0 ; i < ${#compilers[@]} ; i = i + 1 )) ; do
			if $(belongs_to_standard ${compilers[${i}]} ${AdaDep}); then
				debug-print-section "installing for gnat profile ${compilers[${i}]}"

				local DLlocation=${AdalibLibTop}/${compilers[${i}]}
				dodir ${DLlocation}
				cp -dpR "${DL}-${compilers[${i}]}" "${D}/${DLlocation}/${PN}"
				cp -dpR "${DLbin}-${compilers[${i}]}" "${D}/${DLlocation}"/bin
				cp -dpR "${DLgpr}-${compilers[${i}]}" "${D}/${DLlocation}"/gpr
				# create profile-specific specs file
				cp ${LibEnv} "${D}/${SPECSDIR}/${PN}/${compilers[${i}]}"
				sed -i -e "s:%DL%:${DLlocation}/${PN}:g" "${D}/${SPECSDIR}/${PN}/${compilers[${i}]}"
				sed -i -e "s:%DLbin%:${DLlocation}/bin:g" "${D}/${SPECSDIR}/${PN}/${compilers[${i}]}"
				sed -i -e "s:%DLgpr%:${DLlocation}/gpr:g" "${D}/${SPECSDIR}/${PN}/${compilers[${i}]}"
			else
				einfo "skipping gnat profile ${compilers[${i}]}"
			fi
		done
	else
		die "please make sure you have at least one gnat compiler installed!"
	fi
}
