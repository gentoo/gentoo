# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rpm.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @BLURB: convenience class for extracting RPMs

case ${EAPI} in
	7|8) inherit eapi9-pipestatus ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_RPM_ECLASS} ]] ; then
_RPM_ECLASS=1

inherit estack toolchain-funcs

# @ECLASS_VARIABLE: RPM_COMPRESS_TYPE
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Comma-separated list of app-arch/rpm compression formats. If set,
# app-arch/rpm will be allowed as a BDEPEND to unpack distfiles. Must be set
# for EAPI 9. Supported types:
#
# - none (rpm is supported but distfile is uncompressed or builtin zlib)
#
# - bzip2 (.bz2)
#
# - lzma (deprecated pre-xz iteration of the lzma SDK. rpm2targz doesn't
#   support it)
#
# - xz (.xz)
#
# - zstd (.zst)
#
# - "" (empty -- the ebuild hasn't been updated to resolve deprecations)
if [[ ${EAPI} != [78] && -z ${RPM_COMPRESS_TYPE} ]]; then
	die "RPM_COMPRESS_TYPE= must be defined starting with EAPI 9"
fi

_rpm_set_globals() {
	local rpmdep= rpmuse= rpm2tar="true" t= types=()
	IFS=, declare -a 'types=(${RPM_COMPRESS_TYPE})'

	if [[ ${RPM_COMPRESS_TYPE} = none ]]; then
		rpmdep=">=app-arch/rpm-4.19.0"
	elif [[ "${#types[@]}" -gt 0 ]]; then
		for t in "${types[@]}"; do
			case ${t} in
				bzip2|zstd) rpmuse+="${t}(+)," ;;
				lzma) rpmuse+="${t}(+),"; rpm2tar="false" ;;
				xz) rpmuse+="lzma(+)," ;;
				none) die "RPM_COMPRESS_TYPE: 'none' cannot be combined with other values" ;;
				*) die "invalid RPM_COMPRESS_TYPE: ${RPM_COMPRESS_TYPE} (found: ${t})" ;;
			esac
		done
		rpmdep=">=app-arch/rpm-4.19.0"
		[[ ${rpmuse} ]] && rpmdep+="[${rpmuse%,}]"
	fi

	if [[ ${rpm2tar} = true ]]; then
		BDEPEND="
			|| (
				app-arch/rpm2targz
				${rpmdep}
			)
		"
	else
		BDEPEND="${rpmdep}"
	fi
}
_rpm_set_globals
unset -f _rpm_set_globals

# @FUNCTION: rpm_unpack
# @USAGE: <rpms>
# @DESCRIPTION:
# Unpack the contents of the specified rpms like the unpack() function.
rpm_unpack() {
	[[ $# -eq 0 ]] && set -- ${A}
	local a noticed=()

	IFS=, declare -a 'types=(${RPM_COMPRESS_TYPE})'

	for a in "$@" ; do
		echo ">>> Unpacking ${a} to ${PWD}"
		if [[ ${a} == ./* ]] ; then
			: # nothing to do -- path is local
		elif [[ ${a} == "${DISTDIR}"/* ]] ; then
			eqawarn 'QA Notice: do not use ${DISTDIR} with rpm_unpack -- it is added for you'
		elif [[ ${a} == /* ]] ; then
			eqawarn 'QA Notice: do not use full paths with rpm_unpack -- use ./ paths instead'
		else
			a="${DISTDIR}/${a}"
		fi

		local payload= usedep=""
		# grep may fail because no payload or because "unknown error", and distinguishing between
		# the two is problematic. We do a token check that strings works, but rely on rpm failing
		# with its own well-formed die if we erroneously decide no payload USE flag is needed due
		# to external commands failing.
		payload=$($(tc-getSTRINGS) "${a}" | grep -o 'PayloadIs[a-zA-Z]*'; if [[ ${PIPESTATUS[0]} != 0 ]]; then die "strings failed"; fi)

		case ${payload} in
			"") payload=none;; # gzip/uncompressed
			PayloadIsBzip) payload=bzip2 usedep="[bzip2(+)]";;
			PayloadIsXz) payload=xz usedep="[lzma(+)]";;
			PayloadIsLzma) payload=lzma usedep="[lzma(+)]";;
			PayloadIsZstd) payload=zstd usedep="[zstd(+)]";;
		esac

		local use_rpm=
		if [[ ${RPM_COMPRESS_TYPE} = *${payload}* ||
			  ( ${payload} = none && ${RPM_COMPRESS_TYPE} ) ]]; then
			use_rpm=true
		elif ! has "${payload}" "${noticed[@]}"; then
			eqawarn "QA Notice: rpm_unpack called without supporting app-arch/rpm."
			eqawarn "\${RPM_COMPRESS_TYPE} should include '${payload}'."
			noticed+=("${payload}")
		fi

		if [[ ${use_rpm} = true ]] && has_version -b "app-arch/rpm${usedep}"; then
			# prefer it if correct USE is in BDEPEND and installed
			local extracttool=(rpm2archive -n)
		elif [[ ${payload} = lzma ]]; then
			# bug 321439
			die "rpm_unpack called with legacy lzma compression that rpm2targz doesn't support"
		else
			local extracttool=(rpm2tar -O)
		fi

		"${extracttool[@]}" "${a}" | tar xf -
		pipestatus || die "failure unpacking ${a}"
	done
}

# @FUNCTION: srcrpm_unpack
# @USAGE: <rpms>
# @DESCRIPTION:
# Unpack the contents of the specified rpms like the unpack() function as well
# as any archives that it might contain.  Note that the secondary archive
# unpack isn't perfect in that it simply unpacks all archives in the working
# directory (with the assumption that there weren't any to start with).
srcrpm_unpack() {
	[[ $# -eq 0 ]] && set -- ${A}
	rpm_unpack "$@"

	# no .src.rpm files, then nothing to do
	[[ "$* " != *".src.rpm " ]] && return 0

	eshopts_push -s nullglob

	# unpack everything
	local a
	for a in *.tar.{gz,bz2,xz} *.t{gz,bz2,xz} *.zip *.ZIP ; do
		unpack "./${a}"
		rm -f "${a}" || die
	done

	eshopts_pop

	return 0
}

# @FUNCTION: rpm_src_unpack
# @DESCRIPTION:
# Automatically unpack all archives in ${A} including rpms.  If one of the
# archives in a source rpm, then the sub archives will be unpacked as well.
rpm_src_unpack() {
	local a
	for a in ${A} ; do
		case ${a} in
		*.rpm) srcrpm_unpack "${a}" ;;
		*)     unpack "${a}" ;;
		esac
	done
}

fi

EXPORT_FUNCTIONS src_unpack
