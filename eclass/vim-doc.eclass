# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: vim-doc.eclass
# @MAINTAINER:
# vim@gentoo.org
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Eclass for vim{,-plugin}.eclass to update documentation tags.
# @DESCRIPTION:
# This eclass is used by vim.eclass and vim-plugin.eclass to update
# the documentation tags.  This is necessary since vim doesn't look in
# /usr/share/vim/vimfiles/doc for documentation; it only uses the
# versioned directory, for example /usr/share/vim/vim62/doc
#
# We depend on vim being installed, which is satisfied by either the
# DEPEND in vim-plugin or by whatever version of vim is being
# installed by the eclass.

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_VIM_DOC_ECLASS} ]] ; then

# @FUNCTION: update_vim_helptags
# @USAGE:
# @DESCRIPTION:
# Update the documentation tags in the versioned Vim directory.
update_vim_helptags() {
	debug-print-function ${FUNCNAME} "${@}"

	local vimfiles helpfile files vim d

	# This is where vim plugins are installed
	vimfiles="${EROOT}"/usr/share/vim/vimfiles

	if [[ ${PN} != vim-core ]]; then
		# Find a suitable vim binary for updating tags :helptags
		vim=$(type -P vim 2>/dev/null)
		[[ -z "${vim}" ]] && vim=$(type -P gvim 2>/dev/null)
		[[ -z "${vim}" ]] && vim=$(type -P kvim 2>/dev/null)
		if [[ -z "${vim}" ]]; then
			ewarn "No suitable vim binary to rebuild documentation tags"
		fi
	fi

	# Make vim not try to connect to X. See :help gui-x11-start
	# in vim for how this evil trickery works.
	if [[ -n "${vim}" ]] ; then
		ln -s "${vim}" "${T}/tagvim" || die
		vim="${T}/tagvim"
	fi

	# Install the documentation symlinks into the versioned vim
	# directory and run :helptags
	for d in "${EROOT%/}"/usr/share/vim/vim[0-9]*; do
		[[ -d "${d}/doc" ]] || continue	# catch a failed glob

		# Remove links
		readarray -d '' files < <(find "${d}"/doc -name "*.txt" -type l -print0 || die "cannot traverse ${d}/doc" )
		for helpfile in "${files[@]}"; do
			if [[ $(readlink -f "${helpfile}") == "${vimfiles}"/* ]]; then
				rm "${helpfile}" || die
			fi
		done

		# Remove stale dirs, if possible
		readarray -d '' files < <(find "${d}" -print0 || die "cannot traverse ${d}")
		if [[ -f "${d}/doc/tags" && ${#files[@]} -eq 3 ]]; then
			# /usr/share/vim/vim61
			# /usr/share/vim/vim61/doc
			# /usr/share/vim/vim61/doc/tags
			einfo "Removing ${d}"
			rm -r "${d}" || die
			continue
		fi

		# Re-create / install new links
		if [[ -d "${vimfiles}"/doc ]]; then
			for helpfile in "${vimfiles}"/doc/*.txt; do
				if [[ ! -e "${d}/doc/$(basename "${helpfile}")" ]]; then
					ln -s "${helpfile}" "${d}/doc" || die
				fi
			done
		fi

		# Update tags; need a vim binary for this
		if [[ -n "${vim}" ]]; then
			einfo "Updating documentation tags in ${d}"
			DISPLAY= "${vim}" -u NONE -U NONE -T xterm -X -n -f \
				'+set nobackup nomore' \
				"+helptags ${d}/doc" \
				'+qa!' </dev/null &>/dev/null || die
		fi
	done

	if [[ -n "${vim}" && -f "${vim}" ]]; then
		rm "${vim}" || die
	fi
}

_VIM_DOC_ECLASS=1
fi
