# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/vim-doc.eclass,v 1.17 2011/12/27 17:55:12 fauli Exp $
#
# This eclass is used by vim.eclass and vim-plugin.eclass to update
# the documentation tags.  This is necessary since vim doesn't look in
# /usr/share/vim/vimfiles/doc for documentation; it only uses the
# versioned directory, for example /usr/share/vim/vim62/doc
#
# We depend on vim being installed, which is satisfied by either the
# DEPEND in vim-plugin or by whatever version of vim is being
# installed by the eclass.


update_vim_helptags() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EROOT="${ROOT}"
	local vimfiles vim d s

	# This is where vim plugins are installed
	vimfiles="${EROOT}"/usr/share/vim/vimfiles

	if [[ $PN != vim-core ]]; then
		# Find a suitable vim binary for updating tags :helptags
		vim=$(type -P vim 2>/dev/null)
		[[ -z "$vim" ]] && vim=$(type -P gvim 2>/dev/null)
		[[ -z "$vim" ]] && vim=$(type -P kvim 2>/dev/null)
		if [[ -z "$vim" ]]; then
			ewarn "No suitable vim binary to rebuild documentation tags"
		fi
	fi

	# Make vim not try to connect to X. See :help gui-x11-start
	# in vim for how this evil trickery works.
	if [[ -n "${vim}" ]] ; then
		ln -s "${vim}" "${T}/tagvim"
		vim="${T}/tagvim"
	fi

	# Install the documentation symlinks into the versioned vim
	# directory and run :helptags
	for d in "${EROOT%/}"/usr/share/vim/vim[0-9]*; do
		[[ -d "$d/doc" ]] || continue	# catch a failed glob

		# Remove links, and possibly remove stale dirs
		find $d/doc -name \*.txt -type l | while read s; do
			[[ $(readlink "$s") = $vimfiles/* ]] && rm -f "$s"
		done
		if [[ -f "$d/doc/tags" && $(find "$d" | wc -l | tr -d ' ') = 3 ]]; then
			# /usr/share/vim/vim61
			# /usr/share/vim/vim61/doc
			# /usr/share/vim/vim61/doc/tags
			einfo "Removing $d"
			rm -r "$d"
			continue
		fi

		# Re-create / install new links
		if [[ -d $vimfiles/doc ]]; then
			ln -s $vimfiles/doc/*.txt $d/doc 2>/dev/null
		fi

		# Update tags; need a vim binary for this
		if [[ -n "$vim" ]]; then
			einfo "Updating documentation tags in $d"
			DISPLAY= $vim -u NONE -U NONE -T xterm -X -n -f \
				'+set nobackup nomore' \
				"+helptags $d/doc" \
				'+qa!' </dev/null &>/dev/null
		fi
	done

	[[ -n "${vim}" && -f "${vim}" ]] && rm "${vim}"
}
