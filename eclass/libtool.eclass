# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: libtool.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: quickly update bundled libtool code
# @DESCRIPTION:
# This eclass patches ltmain.sh distributed with libtoolized packages with the
# relink and portage patch among others
#
# Note, this eclass does not require libtool as it only applies patches to
# generated libtool files.  We do not run the libtoolize program because that
# requires a regeneration of the main autotool files in order to work properly.

if [[ -z ${_LIBTOOL_ECLASS} ]]; then
_LIBTOOL_ECLASS=1

DEPEND=">=app-portage/elt-patches-20170317"

libtool_elt_patch_dir() {
	echo "${EPREFIX}/usr/share/elt-patches"
}

inherit multilib toolchain-funcs

#
# See if we can apply $2 on $1, and if so, do it
#
ELT_try_and_apply_patch() {
	local ret=0
	local file=$1
	local patch=$2
	local src=$3
	local disp="${src} patch"
	local log="${T}/elibtool.log"

	if [[ -z ${_ELT_NOTED_TMP} ]] ; then
		_ELT_NOTED_TMP=true
		printf 'temp patch: %s\n' "${patch}" > "${log}"
	fi
	printf '\nTrying %s\n' "${disp}" >> "${log}"

	if [[ ! -e ${file} ]] ; then
		echo "File not found: ${file}" >> "${log}"
		return 1
	fi

	# Save file for permission restoration.  `patch` sometimes resets things.
	# Ideally we'd want 'stat -c %a', but stat is highly non portable and we are
	# guaranted to have GNU find, so use that instead.
	local perms="$(find ${file} -maxdepth 0 -printf '%m')"
	# We only support patchlevel of 0 - why worry if its static patches?
	if patch -p0 --dry-run "${file}" "${patch}" >> "${log}" 2>&1 ; then
		einfo "  Applying ${disp} ..."
		patch -p0 -g0 --no-backup-if-mismatch "${file}" "${patch}" >> "${log}" 2>&1
		ret=$?
		export ELT_APPLIED_PATCHES="${ELT_APPLIED_PATCHES} ${src}"
	else
		ret=1
	fi
	chmod "${perms}" "${file}"

	return "${ret}"
}

#
# Get string version of ltmain.sh or ltconfig (passed as $1)
#
ELT_libtool_version() {
	(
	unset VERSION
	eval $(grep -e '^[[:space:]]*VERSION=' "$1")
	echo "${VERSION:-0}"
	)
}

#
# Run through the patches in $2 and see if any
# apply to $1 ...
#
ELT_walk_patches() {
	local patch tmp
	local ret=1
	local file=$1
	local patch_set=$2
	local patch_dir="$(libtool_elt_patch_dir)/${patch_set}"
	local rem_int_dep=$3

	[[ -z ${patch_set} ]] && return 1
	[[ ! -d ${patch_dir} ]] && return 1

	# Allow patches to use @GENTOO_LIBDIR@ replacements
	local sed_args=( -e "s:@GENTOO_LIBDIR@:$(get_libdir):g" )
	if [[ -n ${rem_int_dep} ]] ; then
		# replace @REM_INT_DEP@ with what was passed
		# to --remove-internal-dep
		sed_args+=( -e "s|@REM_INT_DEP@|${rem_int_dep}|g" )
	fi

	pushd "$(libtool_elt_patch_dir)" >/dev/null || die

	# Go through the patches in reverse order (newer version to older)
	for patch in $(find "${patch_set}" -maxdepth 1 -type f | LC_ALL=C sort -r) ; do
		tmp="${T}/libtool-elt.patch"
		sed "${sed_args[@]}" "${patch}" > "${tmp}" || die
		if ELT_try_and_apply_patch "${file}" "${tmp}" "${patch}" ; then
			# Break to unwind w/popd rather than return directly
			ret=0
			break
		fi
	done

	popd >/dev/null
	return ${ret}
}

# @FUNCTION: elibtoolize
# @USAGE: [dirs] [--portage] [--reverse-deps] [--patch-only] [--remove-internal-dep=xxx] [--shallow] [--no-uclibc]
# @DESCRIPTION:
# Apply a smorgasbord of patches to bundled libtool files.  This function
# should always be safe to run.  If no directories are specified, then
# ${S} will be searched for appropriate files.
#
# If the --shallow option is used, then only ${S}/ltmain.sh will be patched.
#
# The other options should be avoided in general unless you know what's going on.
elibtoolize() {
	local x
	local dirs=()
	local do_portage="no"
	local do_reversedeps="yes"
	local do_only_patches="no"
	local do_uclibc="yes"
	local deptoremove=
	local do_shallow="no"
	local force="false"
	local elt_patches="install-sh ltmain portage relink max_cmd_len sed test tmp cross as-needed target-nm ppc64le"

	for x in "$@" ; do
		case ${x} in
			--portage)
				# Only apply portage patch, and don't
				# 'libtoolize --copy --force' if all patches fail.
				do_portage="yes"
				;;
			--reverse-deps)
				# Apply the reverse-deps patch
				# http://bugzilla.gnome.org/show_bug.cgi?id=75635
				do_reversedeps="yes"
				elt_patches+=" fix-relink"
				;;
			--patch-only)
				# Do not run libtoolize if none of the patches apply ..
				do_only_patches="yes"
				;;
			--remove-internal-dep=*)
				# We will replace @REM_INT_DEP@ with what is needed
				# in ELT_walk_patches() ...
				deptoremove=${x#--remove-internal-dep=}

				# Add the patch for this ...
				[[ -n ${deptoremove} ]] && elt_patches+=" rem-int-dep"
				;;
			--shallow)
				# Only patch the ltmain.sh in ${S}
				do_shallow="yes"
				;;
			--no-uclibc)
				do_uclibc="no"
				;;
			--force)
				force="true"
				;;
			-*)
				eerror "Invalid elibtoolize option: ${x}"
				die "elibtoolize called with ${x} ??"
				;;
			*)	dirs+=( "${x}" )
		esac
	done

	[[ ${do_uclibc} == "yes" ]] && elt_patches+=" uclibc-conf uclibc-ltconf"

	case ${CHOST} in
		*-aix*)     elt_patches+=" hardcode aixrtl" ;; #213277
		*-darwin*)  elt_patches+=" darwin-ltconf darwin-ltmain darwin-conf" ;;
		*-solaris*) elt_patches+=" sol2-conf sol2-ltmain" ;;
		*-freebsd*) elt_patches+=" fbsd-conf fbsd-ltconf" ;;
		*-hpux*)    elt_patches+=" hpux-conf deplibs hc-flag-ld hardcode hardcode-relink relink-prog no-lc" ;;
		*-irix*)    elt_patches+=" irix-ltmain" ;;
		*-mint*)    elt_patches+=" mint-conf" ;;
	esac

	if $(tc-getLD) --version 2>&1 | grep -qs 'GNU gold'; then
		elt_patches+=" gold-conf"
	fi

	# Find out what dirs to scan.
	if [[ ${do_shallow} == "yes" ]] ; then
		[[ ${#dirs[@]} -ne 0 ]] && die "Using --shallow with explicit dirs doesn't make sense"
		[[ -f ${S}/ltmain.sh || -f ${S}/configure ]] && dirs+=( "${S}" )
	else
		[[ ${#dirs[@]} -eq 0 ]] && dirs+=( "${S}" )
		dirs=( $(find "${dirs[@]}" '(' -name ltmain.sh -o -name configure ')' -printf '%h\n' | sort -u) )
	fi

	local d p ret
	for d in "${dirs[@]}" ; do
		export ELT_APPLIED_PATCHES=

		if [[ -f ${d}/.elibtoolized ]] ; then
			${force} || continue
		fi

		local outfunc="einfo"
		[[ -f ${d}/.elibtoolized ]] && outfunc="ewarn"
		${outfunc} "Running elibtoolize in: ${d#${WORKDIR}/}/"
		if [[ ${outfunc} == "ewarn" ]] ; then
			ewarn "  We've already been run in this tree; you should"
			ewarn "  avoid this if possible (perhaps by filing a bug)"
		fi

		# patching ltmain.sh
		[[ -f ${d}/ltmain.sh ]] &&
		for p in ${elt_patches} ; do
			ret=0

			case ${p} in
				portage)
					# Stupid test to see if its already applied ...
					if ! grep -qs 'We do not want portage' "${d}/ltmain.sh" ; then
						ELT_walk_patches "${d}/ltmain.sh" "${p}"
						ret=$?
					fi
					;;
				rem-int-dep)
					ELT_walk_patches "${d}/ltmain.sh" "${p}" "${deptoremove}"
					ret=$?
					;;
				fix-relink)
					# Do not apply if we do not have the relink patch applied ...
					if grep -qs 'inst_prefix_dir' "${d}/ltmain.sh" ; then
						ELT_walk_patches "${d}/ltmain.sh" "${p}"
						ret=$?
					fi
					;;
				max_cmd_len)
					# Do not apply if $max_cmd_len is not used ...
					if grep -qs 'max_cmd_len' "${d}/ltmain.sh" ; then
						ELT_walk_patches "${d}/ltmain.sh" "${p}"
						ret=$?
					fi
					;;
				as-needed)
					ELT_walk_patches "${d}/ltmain.sh" "${p}"
					ret=$?
					;;
				uclibc-ltconf)
					# Newer libtoolize clears ltconfig, as not used anymore
					if [[ -s ${d}/ltconfig ]] ; then
						ELT_walk_patches "${d}/ltconfig" "${p}"
						ret=$?
					fi
					;;
				fbsd-ltconf)
					if [[ -s ${d}/ltconfig ]] ; then
						ELT_walk_patches "${d}/ltconfig" "${p}"
						ret=$?
					fi
					;;
				darwin-ltconf)
					# Newer libtoolize clears ltconfig, as not used anymore
					if [[ -s ${d}/ltconfig ]] ; then
						ELT_walk_patches "${d}/ltconfig" "${p}"
						ret=$?
					fi
					;;
				darwin-ltmain)
					# special case to avoid false positives (failing to apply
					# ltmain.sh path message), newer libtools have this patch
					# built in, so not much to patch around then
					if [[ -e ${d}/ltmain.sh ]] && \
					   ! grep -qs 'verstring="-compatibility_version' "${d}/ltmain.sh" ; then
						ELT_walk_patches "${d}/ltmain.sh" "${p}"
						ret=$?
					fi
					;;
				install-sh)
					ELT_walk_patches "${d}/install-sh" "${p}"
					ret=$?
					;;
				cross)
					if tc-is-cross-compiler ; then
						ELT_walk_patches "${d}/ltmain.sh" "${p}"
						ret=$?
					fi
					;;
				*)
					ELT_walk_patches "${d}/ltmain.sh" "${p}"
					ret=$?
					;;
			esac

			if [[ ${ret} -ne 0 ]] ; then
				case ${p} in
					relink)
						local version=$(ELT_libtool_version "${d}/ltmain.sh")
						# Critical patch, but could be applied ...
						# FIXME:  Still need a patch for ltmain.sh > 1.4.0
						if ! grep -qs 'inst_prefix_dir' "${d}/ltmain.sh" && \
						   [[ $(VER_to_int "${version}") -ge $(VER_to_int "1.4.0") ]] ; then
							ewarn "  Could not apply relink.patch!"
						fi
						;;
					portage)
						# Critical patch - for this one we abort, as it can really
						# cause breakage without it applied!
						if [[ ${do_portage} == "yes" ]] ; then
							# Stupid test to see if its already applied ...
							if ! grep -qs 'We do not want portage' "${d}/ltmain.sh" ; then
								echo
								eerror "Portage patch requested, but failed to apply!"
								eerror "Please file a bug report to add a proper patch."
								die "Portage patch requested, but failed to apply!"
							fi
						else
							if grep -qs 'We do not want portage' "${d}/ltmain.sh" ; then
							#	ewarn "  Portage patch seems to be already applied."
							#	ewarn "  Please verify that it is not needed."
								:
							else
								local version=$(ELT_libtool_version "${d}"/ltmain.sh)
								echo
								eerror "Portage patch failed to apply (ltmain.sh version ${version})!"
								eerror "Please file a bug report to add a proper patch."
								die "Portage patch failed to apply!"
							fi
							# We do not want to run libtoolize ...
							ELT_APPLIED_PATCHES="portage"
						fi
						;;
					darwin-*)
						[[ ${CHOST} == *"-darwin"* ]] && ewarn "  Darwin patch set '${p}' failed to apply!"
						;;
				esac
			fi
		done

		# makes sense for ltmain.sh patches only
		[[ -f ${d}/ltmain.sh ]] &&
		if [[ -z ${ELT_APPLIED_PATCHES} ]] ; then
			if [[ ${do_portage} == "no" && \
				  ${do_reversedeps} == "no" && \
				  ${do_only_patches} == "no" && \
				  ${deptoremove} == "" ]]
			then
				ewarn "Cannot apply any patches, please file a bug about this"
				die
			fi
		fi

		# patching configure
		[[ -f ${d}/configure ]] &&
		for p in ${elt_patches} ; do
			ret=0

			case ${p} in
				uclibc-conf)
					if grep -qs 'Transform linux' "${d}/configure" ; then
						ELT_walk_patches "${d}/configure" "${p}"
						ret=$?
					fi
					;;
				fbsd-conf)
					if grep -qs 'version_type=freebsd-' "${d}/configure" ; then
						ELT_walk_patches "${d}/configure" "${p}"
						ret=$?
					fi
					;;
				darwin-conf)
					if grep -qs '&& echo \.so ||' "${d}/configure" ; then
						ELT_walk_patches "${d}/configure" "${p}"
						ret=$?
					fi
					;;
				aixrtl|hpux-conf)
					ret=1
					local subret=0
					# apply multiple patches as often as they match
					while [[ $subret -eq 0 ]]; do
						subret=1
						if [[ -e ${d}/configure ]]; then
							ELT_walk_patches "${d}/configure" "${p}"
							subret=$?
						fi
						if [[ $subret -eq 0 ]]; then
							# have at least one patch succeeded.
							ret=0
						fi
					done
					;;
				mint-conf|gold-conf|sol2-conf)
					ELT_walk_patches "${d}/configure" "${p}"
					ret=$?
					;;
				target-nm)
					ELT_walk_patches "${d}/configure" "${p}"
					ret=$?
					;;
				ppc64le)
					ELT_walk_patches "${d}/configure" "${p}"
					ret=$?
					;;
				*)
					# ltmain.sh patches are applied above
					;;
			esac

			if [[ ${ret} -ne 0 ]] ; then
				case ${p} in
					uclibc-*)
						[[ ${CHOST} == *-uclibc ]] && ewarn "  uClibc patch set '${p}' failed to apply!"
						;;
					fbsd-*)
						if [[ ${CHOST} == *-freebsd* ]] ; then
							if [[ -z $(grep 'Handle Gentoo/FreeBSD as it was Linux' \
								"${d}/configure" 2>/dev/null) ]]; then
								eerror "  FreeBSD patch set '${p}' failed to apply!"
								die "FreeBSD patch set '${p}' failed to apply!"
							fi
						fi
						;;
					darwin-*)
						[[ ${CHOST} == *"-darwin"* ]] && ewarn "  Darwin patch set '${p}' failed to apply!"
						;;
				esac
			fi
		done

		rm -f "${d}/libtool"

		> "${d}/.elibtoolized"
	done
}

uclibctoolize() { die "Use elibtoolize"; }
darwintoolize() { die "Use elibtoolize"; }

# char *VER_major(string)
#
#    Return the Major (X of X.Y.Z) version
#
VER_major() {
	[[ -z $1 ]] && return 1

	local VER=$@
	echo "${VER%%[^[:digit:]]*}"
}

# char *VER_minor(string)
#
#    Return the Minor (Y of X.Y.Z) version
#
VER_minor() {
	[[ -z $1 ]] && return 1

	local VER=$@
	VER=${VER#*.}
	echo "${VER%%[^[:digit:]]*}"
}

# char *VER_micro(string)
#
#    Return the Micro (Z of X.Y.Z) version.
#
VER_micro() {
	[[ -z $1 ]] && return 1

	local VER=$@
	VER=${VER#*.*.}
	echo "${VER%%[^[:digit:]]*}"
}

# int VER_to_int(string)
#
#    Convert a string type version (2.4.0) to an int (132096)
#    for easy compairing or versions ...
#
VER_to_int() {
	[[ -z $1 ]] && return 1

	local VER_MAJOR=$(VER_major "$1")
	local VER_MINOR=$(VER_minor "$1")
	local VER_MICRO=$(VER_micro "$1")
	local VER_int=$(( VER_MAJOR * 65536 + VER_MINOR * 256 + VER_MICRO ))

	# We make version 1.0.0 the minimum version we will handle as
	# a sanity check ... if its less, we fail ...
	if [[ ${VER_int} -ge 65536 ]] ; then
		echo "${VER_int}"
		return 0
	fi

	echo 1
	return 1
}

fi
