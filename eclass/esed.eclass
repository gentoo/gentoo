# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: esed.eclass
# @MAINTAINER:
# Ionen Wolkens <ionen@gentoo.org>
# @AUTHOR:
# Ionen Wolkens <ionen@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: sed(1) and alike wrappers that die if did not modify any files
# @EXAMPLE:
#
# @CODE
# # sed(1) wrappers, die if no changes
# esed s/a/b/ file.c # -i is default
# enewsed s/a/b/ project.pc.in "${T}"/project.pc
#
# # bash-only simple fixed string alternatives, also die if no changes
# erepl string replace file.c
# ereplp ^match string replace file.c # like /^match/s:string:replace:g
# erepld ^match file.c # deletes matching lines, like /^match/d
# use prefix && enewreplp ^prefix= /usr "${EPREFIX}"/usr pn.pc.in pn.pc
#
# # find(1) wrapper that sees shell functions, dies if no files found
# efind . -name '*.c' -erun esed s/a/b/ # dies if no files changed
# efind . -name '*.c' -erun sed s/a/b/ # only dies if no files found
# @CODE
#
# Migration notes: be wary of non-deterministic cases involving variables,
# e.g. s|lib|$(get_libdir)|, s|-O3|${CFLAGS}|, or s|/usr|${EPREFIX}/usr|.
# erepl/esed() die if these do nothing, like libdir being 'lib' on x86.
# Either verify, keep sed(1), or ensure a change (extra space, @libdir@).
#
# Where possible, it is also good to consider if using patches is more
# suitable to ensure adequate changes.  These functions are also unsafe
# for binary files containing null bytes (erepl() will remove them).

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ESED_ECLASS} ]]; then
_ESED_ECLASS=1

# @ECLASS_VARIABLE: ESED_VERBOSE
# @DEFAULT_UNSET
# @USER_VARIABLE
# @DESCRIPTION:
# If set to a non-empty value, erepl/esed() and wrappers will use diff(1)
# to display file differences.  Recommended for maintainers to easily
# confirm the changes being made.

# @FUNCTION: esed
# @USAGE: [-E|-r|-n] [-e <expression>]... [--] <file>...
# @DESCRIPTION:
# sed(1) wrapper that dies if any of the expressions did not modify any files.
# sed's -i/--in-place is forced, -e can be omitted if only one expression, and
# arguments must be passed in the listed order with files last.  Each -e will
# be a separate sed(1) call to evaluate changes of each.
esed() {
	[[ ${#} -ge 2 ]] \
		|| die "too few arguments for ${_esed_cmd[0]:-${FUNCNAME[0]}}"

	local args=() contents=() endopts= exps=() files=()
	while (( ${#} )); do
		if [[ ${1} == -* && ! ${endopts} ]]; then
			case ${1} in
				--) endopts=1 ;;
				-E|-n|-r) args+=( ${1} ) ;;
				-e)
					shift
					(( ${#} )) || die "missing argument to -e"
					exps+=( "${1}" )
					;;
				*) die "unrecognized option for ${FUNCNAME[0]}" ;;
			esac
		elif (( ! ${#exps[@]} )); then
			exps+=( "${1}" ) # like sed, if no -e, first non-option is exp
		else
			[[ -f ${1} ]] || die "mssing or not a normal file: ${1}"
			files+=( "${1}" )
			contents+=( "$(<"${1}")" ) || die "failed reading: ${1}"
		fi
		shift
	done
	(( ${#files[@]} )) || die "no files in ${FUNCNAME[0]} arguments"

	if [[ ${_esed_output} ]]; then
		[[ ${#files[@]} -eq 1 ]] \
			|| die "${_esed_cmd[0]} needs exactly one input file"

		# swap file for output to simplify sequential sed'ing
		cp -- "${files[0]}" "${_esed_output}" || die
		files[0]=${_esed_output}
	fi

	local -i i
	local changed exp newcontents sed
	for exp in "${exps[@]}"; do
		sed=( sed -i "${args[@]}" -e "${exp}" -- "${files[@]}" )
		[[ ${ESED_VERBOSE} ]] && einfo "${sed[*]}"

		"${sed[@]}" </dev/null || die "failed: ${sed[*]}"

		changed=
		for ((i=0; i<${#files[@]}; i++)); do
			newcontents=$(<"${files[i]}") || die "failed reading: ${files[i]}"

			if [[ ${contents[i]} != "${newcontents}" ]]; then
				changed=1

				[[ ${ESED_VERBOSE} ]] || break

				diff -u --color --label="${files[i]}"{,} \
					<(echo "${contents[i]}") <(echo "${newcontents}")
			fi
		done

		[[ ${changed} ]] \
			|| die "no-op: ${sed[*]}${_esed_cmd[0]:+ (from: ${_esed_cmd[*]})}"
	done
}

# @FUNCTION: enewsed
# @USAGE: <esed-argument>... <output-file>
# @DESCRIPTION:
# esed() wrapper to save the result to <output-file>.  Intended to replace
# ``sed ... input > output`` given esed() does not support stdin/out.
enewsed() {
	local _esed_cmd=( ${FUNCNAME[0]} "${@}" )
	local _esed_output=${*: -1:1}
	esed "${@:1:${#}-1}"
}

# @FUNCTION: erepl
# @USAGE: <string> <replacement> <file>...
# @DESCRIPTION:
# Do basic bash ``${<file>//"<string>"/<replacement>}`` per-line no-glob
# replacement in file(s).  Dies if no changes were made.  Suggested over
# sed(1) where possible for simplicity and avoiding issues with delimiters.
# Warning: erepl-based functions strip null bytes, use for text only.
erepl() {
	local _esed_cmd=( ${FUNCNAME[0]} "${@}" )
	ereplp '.*' "${@}"
}

# @FUNCTION: enewrepl
# @USAGE: <erepl-argument>... <output-file>
# @DESCRIPTION:
# erepl() wrapper to save the result to <output-file>.
enewrepl() {
	local _esed_cmd=( ${FUNCNAME[0]} "${@}" )
	local _esed_output=${*: -1:1}
	ereplp '.*' "${@:1:${#}-1}"
}

# @FUNCTION: erepld
# @USAGE: <line-pattern-match> <file>...
# @DESCRIPTION:
# Deletes lines in file(s) matching ``[[ ${line} =~ <pattern> ]]``.
erepld() {
	local _esed_cmd=( ${FUNCNAME[0]} "${@}" )
	local _esed_argsmin=2
	local _esed_repld=1
	ereplp "${@}"
}

# @FUNCTION: enewrepld
# @USAGE: <erepld-argument>... <output-file>
# @DESCRIPTION:
# erepl() wrapper to save the result to <output-file>.
enewrepld() {
	local _esed_cmd=( ${FUNCNAME[0]} "${@}" )
	local _esed_output=${*: -1:1}
	erepld "${@:1:${#}-1}"
}

# @FUNCTION: ereplp
# @USAGE: <line-match-pattern> <string> <replacement> <file>...
# @DESCRIPTION:
# Like erepl() but replaces only on ``[[ ${line} =~ <pattern> ]]``.
ereplp() {
	local -i argsmin=${_esed_argsmin:-4}
	[[ ${#} -ge ${argsmin} ]] \
		|| die "too few arguments for ${_esed_cmd[0]:-${FUNCNAME[0]}}"

	[[ ! ${_esed_output} || ${#} -le ${argsmin} ]] \
		|| die "${_esed_cmd[0]} needs exactly one input file"

	local contents changed= file line newcontents
	for file in "${@:argsmin}"; do
		mapfile contents < "${file}" || die
		newcontents=()

		for line in "${contents[@]}"; do
			if [[ ${line} =~ ${1} ]]; then
				if [[ ${_esed_repld} ]]; then
					changed=1
				else
					newcontents+=( "${line//"${2}"/${3}}" )
					[[ ${line} != "${newcontents[-1]}" ]] && changed=1
				fi
			else
				newcontents+=( "${line}" )
			fi
		done
		printf %s "${newcontents[@]}" > "${_esed_output:-${file}}" || die

		if [[ ${ESED_VERBOSE} ]]; then
			einfo "${FUNCNAME[0]} ${*:1:argsmin-1} ${file}${_esed_output:+ (to: ${_esed_output})}"
			diff -u --color --label="${file}" --label="${_esed_output:-${file}}" \
				<(printf %s "${contents[@]}") <(printf %s "${newcontents[@]}")
		fi
	done

	[[ ${changed} ]] || die "no-op: ${_esed_cmd[*]:-${FUNCNAME[0]} ${*}}"
}

# @FUNCTION: enewreplp
# @USAGE: <ereplp-argument>... <output-file>
# @DESCRIPTION:
# ereplp() wrapper to save the result to <output-file>.
enewreplp() {
	local _esed_cmd=( ${FUNCNAME[0]} "${@}" )
	local _esed_output=${*: -1:1}
	ereplp "${@:1:${#}-1}"
}

# @FUNCTION: efind
# @USAGE: <find-argument>... -erun <command> <argument>...
# @DESCRIPTION:
# find(1) wrapper that dies if no files were found.  <command> can be a shell
# function, e.g. ``efind ... -erun erepl /usr /opt``.  -print0 is added to
# find arguments, and found files to end of arguments (``{} +`` is unused).
# Found files must not exceed args limits.  Use is discouraged if files add
# up to a large total size (50+MB), notably with slower erepl/esed().  Shell
# functions called this way are expected to ``|| die`` themselves on error.
efind() {
	[[ ${#} -ge 3 ]] || die "too few arguments for ${FUNCNAME[0]}"

	local _esed_cmd=( ${FUNCNAME[0]} "${@}" )

	local find=( find )
	while (( ${#} )); do
		if [[ ${1} == -erun ]]; then
			shift
			break
		fi
		find+=( "${1}" )
		shift
	done
	find+=( -print0 )

	local files
	mapfile -d '' -t files < <("${find[@]}" || die "failed: ${find[*]}")

	(( ${#files[@]} )) || die "no files from: ${find[*]}"
	(( ${#} )) || die "missing -erun arguments for ${FUNCNAME[0]}"

	# skip `|| die` for shell functions (should be handled internally)
	if declare -f "${1}" >/dev/null; then
		"${@}" "${files[@]}"
	else
		"${@}" "${files[@]}" || die "failed: ${*} ${files[*]}"
	fi
}

fi
