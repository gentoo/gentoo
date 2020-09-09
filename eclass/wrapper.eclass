# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: wrapper.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: create a shell wrapper script

if [[ -z ${_WRAPPER_ECLASS} ]]; then
_WRAPPER_ECLASS=1

# @FUNCTION: make_wrapper
# @USAGE: <wrapper> <target> [chdir] [libpaths] [installpath]
# @DESCRIPTION:
# Create a shell wrapper script named wrapper in installpath
# (defaults to the bindir) to execute target (default of wrapper)
# by first optionally setting LD_LIBRARY_PATH to the colon-delimited
# libpaths followed by optionally changing directory to chdir.
make_wrapper() {
	local wrapper=$1 bin=$2 chdir=$3 libdir=$4 path=$5
	local tmpwrapper="${T}/tmp.wrapper.${wrapper##*/}"
	has "${EAPI:-0}" 0 1 2 && local EPREFIX=""

	(
	echo '#!/bin/sh'
	if [[ -n ${libdir} ]] ; then
		local var
		if [[ ${CHOST} == *-darwin* ]] ; then
			var=DYLD_LIBRARY_PATH
		else
			var=LD_LIBRARY_PATH
		fi
		cat <<-EOF
			if [ "\${${var}+set}" = "set" ] ; then
				export ${var}="\${${var}}:${EPREFIX}${libdir}"
			else
				export ${var}="${EPREFIX}${libdir}"
			fi
		EOF
	fi
	[[ -n ${chdir} ]] && printf 'cd "%s" &&\n' "${EPREFIX}${chdir}"
	# We don't want to quote ${bin} so that people can pass complex
	# things as ${bin} ... "./someprog --args"
	printf 'exec %s "$@"\n' "${bin/#\//${EPREFIX}/}"
	) > "${tmpwrapper}"
	chmod go+rx "${tmpwrapper}"

	if [[ -n ${path} ]] ; then
		(
		exeopts -m 0755
		exeinto "${path}"
		newexe "${tmpwrapper}" "${wrapper}"
		) || die
	else
		newbin "${tmpwrapper}" "${wrapper}" || die
	fi
}

fi
