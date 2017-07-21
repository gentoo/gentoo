# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/gentoo/gentoo-syntax.git"
	inherit git-r3
else
	SRC_URI="https://github.com/gentoo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Gentoo and portage related syntax highlighting, filetype, and indent settings"
HOMEPAGE="https://github.com/gentoo/gentoo-syntax"
LICENSE="vim"
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
		else
			elog "Note for developers and anyone else who edits ebuilds:"
			elog "    This release of gentoo-syntax now contains filetype rules to set"
			elog "    fileencoding for ebuilds and ChangeLogs to utf-8 as per GLEP 31."
			elog "    If you find this feature breaks things, please submit a bug and"
			elog "    assign it to vim@gentoo.org. You can use the 'ignore-glep31' USE"
			elog "    flag to remove these rules."
		fi
	fi
}
