# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: usr-ldscript.eclass
# @MAINTAINER:
# Toolchain Ninjas <toolchain@gentoo.org>
# @SUPPORTED_EAPIS: 4 5 6 7
# @BLURB: Defines the gen_usr_ldscript function.

if [[ -z ${_USR_LDSCRIPT_ECLASS} ]]; then
_USR_LDSCRIPT_ECLASS=1

case ${EAPI:-0} in
	4|5|6|7) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

inherit multilib toolchain-funcs

IUSE="split-usr"

# @FUNCTION: gen_usr_ldscript
# @USAGE: [-a] <list of libs to create linker scripts for>
# @DESCRIPTION:
# This function generate linker scripts in /usr/lib for dynamic
# libs in /lib.  This is to fix linking problems when you have
# the .so in /lib, and the .a in /usr/lib.  What happens is that
# in some cases when linking dynamic, the .a in /usr/lib is used
# instead of the .so in /lib due to gcc/libtool tweaking ld's
# library search path.  This causes many builds to fail.
# See bug #4411 for more info.
#
# Note that you should in general use the unversioned name of
# the library (libfoo.so), as ldconfig should usually update it
# correctly to point to the latest version of the library present.
gen_usr_ldscript() {
	local lib libdir=$(get_libdir) output_format="" auto=false suffix=$(get_libname)

	tc-is-static-only && return

	# We only care about stuffing / for the native ABI. #479448
	if [[ $(type -t multilib_is_native_abi) == "function" ]] ; then
		multilib_is_native_abi || return 0
	fi

	# Eventually we'd like to get rid of this func completely #417451
	case ${CTARGET:-${CHOST}} in
	*-darwin*) ;;
	*-android*) return 0 ;;
	*linux*|*-freebsd*|*-openbsd*|*-netbsd*)
		use prefix && return 0
		use split-usr || return 0
		;;
	*) return 0 ;;
	esac

	# Just make sure it exists
	dodir /usr/${libdir}

	if [[ $1 == "-a" ]] ; then
		auto=true
		shift
		dodir /${libdir}
	fi

	# OUTPUT_FORMAT gives hints to the linker as to what binary format
	# is referenced ... makes multilib saner
	local flags=( ${CFLAGS} ${LDFLAGS} -Wl,--verbose )
	if $(tc-getLD) --version | grep -q 'GNU gold' ; then
		# If they're using gold, manually invoke the old bfd. #487696
		local d="${T}/bfd-linker"
		mkdir -p "${d}"
		ln -sf $(which ${CHOST}-ld.bfd) "${d}"/ld
		flags+=( -B"${d}" )
	fi
	output_format=$($(tc-getCC) "${flags[@]}" 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

	for lib in "$@" ; do
		local tlib
		if ${auto} ; then
			lib="lib${lib}${suffix}"
		else
			# Ensure /lib/${lib} exists to avoid dangling scripts/symlinks.
			# This especially is for AIX where $(get_libname) can return ".a",
			# so /lib/${lib} might be moved to /usr/lib/${lib} (by accident).
			[[ -r ${ED%/}/${libdir}/${lib} ]] || continue
			#TODO: better die here?
		fi

		case ${CTARGET:-${CHOST}} in
		*-darwin*)
			if ${auto} ; then
				tlib=$(scanmacho -qF'%S#F' "${ED%/}"/usr/${libdir}/${lib})
			else
				tlib=$(scanmacho -qF'%S#F' "${ED%/}"/${libdir}/${lib})
			fi
			[[ -z ${tlib} ]] && die "unable to read install_name from ${lib}"
			tlib=${tlib##*/}

			if ${auto} ; then
				mv "${ED%/}"/usr/${libdir}/${lib%${suffix}}.*${suffix#.} "${ED%/}"/${libdir}/ || die
				# some install_names are funky: they encode a version
				if [[ ${tlib} != ${lib%${suffix}}.*${suffix#.} ]] ; then
					mv "${ED%/}"/usr/${libdir}/${tlib%${suffix}}.*${suffix#.} "${ED%/}"/${libdir}/ || die
				fi
				rm -f "${ED%/}"/${libdir}/${lib}
			fi

			# Mach-O files have an id, which is like a soname, it tells how
			# another object linking against this lib should reference it.
			# Since we moved the lib from usr/lib into lib this reference is
			# wrong.  Hence, we update it here.  We don't configure with
			# libdir=/lib because that messes up libtool files.
			# Make sure we don't lose the specific version, so just modify the
			# existing install_name
			if [[ ! -w "${ED%/}/${libdir}/${tlib}" ]] ; then
				chmod u+w "${ED%/}/${libdir}/${tlib}" # needed to write to it
				local nowrite=yes
			fi
			install_name_tool \
				-id "${EPREFIX}"/${libdir}/${tlib} \
				"${ED%/}"/${libdir}/${tlib} || die "install_name_tool failed"
			[[ -n ${nowrite} ]] && chmod u-w "${ED%/}/${libdir}/${tlib}"
			# Now as we don't use GNU binutils and our linker doesn't
			# understand linker scripts, just create a symlink.
			pushd "${ED%/}/usr/${libdir}" > /dev/null
			ln -snf "../../${libdir}/${tlib}" "${lib}"
			popd > /dev/null
			;;
		*)
			if ${auto} ; then
				tlib=$(scanelf -qF'%S#F' "${ED%/}"/usr/${libdir}/${lib})
				[[ -z ${tlib} ]] && die "unable to read SONAME from ${lib}"
				mv "${ED%/}"/usr/${libdir}/${lib}* "${ED%/}"/${libdir}/ || die
				# some SONAMEs are funky: they encode a version before the .so
				if [[ ${tlib} != ${lib}* ]] ; then
					mv "${ED%/}"/usr/${libdir}/${tlib}* "${ED%/}"/${libdir}/ || die
				fi
				rm -f "${ED%/}"/${libdir}/${lib}
			else
				tlib=${lib}
			fi
			cat > "${ED%/}/usr/${libdir}/${lib}" <<-END_LDSCRIPT
			/* GNU ld script
			   Since Gentoo has critical dynamic libraries in /lib, and the static versions
			   in /usr/lib, we need to have a "fake" dynamic lib in /usr/lib, otherwise we
			   run into linking problems.  This "fake" dynamic lib is a linker script that
			   redirects the linker to the real lib.  And yes, this works in the cross-
			   compiling scenario as the sysroot-ed linker will prepend the real path.

			   See bug https://bugs.gentoo.org/4411 for more info.
			 */
			${output_format}
			GROUP ( ${EPREFIX}/${libdir}/${tlib} )
			END_LDSCRIPT
			;;
		esac
		fperms a+x "/usr/${libdir}/${lib}" || die "could not change perms on ${lib}"
	done
}

fi # _USR_LDSCRIPT_ECLASS
