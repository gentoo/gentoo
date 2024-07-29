# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 vim-plugin

DESCRIPTION="vim plugin: Gentoo and Portage syntax highlighting"
HOMEPAGE="https://github.com/gentoo/gentoo-syntax/"
EGIT_REPO_URI="
	https://anongit.gentoo.org/git/proj/gentoo-syntax.git
	https://github.com/gentoo/gentoo-syntax.git
"

LICENSE="vim"
SLOT="0"
IUSE="ignore-glep31"

VIM_PLUGIN_HELPFILES="gentoo-syntax"
VIM_PLUGIN_MESSAGES="filetype"

src_prepare() {
	default
	if use ignore-glep31 ; then
		for f in ftplugin/*.vim ; do
			ebegin "Removing UTF-8 rules from ${f} ..."
			sed -i -e 's~\(setlocal fileencoding=utf-8\)~" \1~' ${f} \
				|| die "waah! bad sed voodoo. need more goats."
			eend $?
		done
	fi
}

pkg_postinst() {
	vim-plugin_pkg_postinst

	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		if use ignore-glep31 1>/dev/null ; then
			ewarn "You have chosen to disable the rules which ensure GLEP 31"
			ewarn "compliance. When editing ebuilds, please make sure you get"
			ewarn "the character set correct."
		fi
	fi
}
