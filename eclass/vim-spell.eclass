# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: vim-spell.eclass
# @MAINTAINER:
# Vim Maintainers <vim@gentoo.org>
# @AUTHOR:
# Ciaran McCreesh <ciaranm@gentoo.org>
# @BLURB: Eclass for managing Vim spell files.
# @DESCRIPTION:
# How to make a vim spell file package using prebuilt spell lists
# from upstream (${CODE} is the language's two letter code):
#
# * Get the ${CODE}.*.spl, ${CODE}.*.sug (if your language has them) and
#   README_${CODE}.txt files. Currently they're at
#   ftp://ftp.vim.org/pub/vim/unstable/runtime/spell/ (except for English,
#   which should be taken from CVS instead).
#
# * Stick them in vim-spell-${CODE}-$(date --iso | tr -d - ).tar.bz2 . Make sure
#   that they're in the appropriately named subdirectory to avoid having to mess
#   with S=.
#
# * Upload the tarball to the Gentoo mirrors.
#
# * Add your spell file to package.mask next to the other vim things. Vim
#   Project members will handle unmasking your spell packages when vim comes out
#   of package.mask.
#
# * Create the app-vim/vim-spell-${CODE} package. You should base your ebuild
#   upon app-vim/vim-spell-en. You will need to change VIM_SPELL_LANGUAGE,
#   KEYWORDS and LICENSE. Check the license carefully! The README will tell
#   you what it is.
#
# * Don't forget metadata.xml. You should list the Vim project and yourself
#   as maintainers. There is no need to join the Vim project just for spell
#   files. Here's an example of a metadata.xml file:
#
#     <?xml version="1.0" encoding="UTF-8"?>
#     <!DOCTYPE pkgmetadata SYSTEM "https://www.gentoo.org/dtd/metadata.dtd">
#     <pkgmetadata>
#        <maintainer type="person">
#                <email>your@email.tld</email>
#                <name>Your Name</name>
#        </maintainer>
#        <maintainer type="project">
#                <email>vim@gentoo.org</email>
#                <name>Vim Maintainers</name>
#        </maintainer>
#
#     	<longdescription lang="en">
#     		Vim spell files for French (fr). Supported character sets are
#     		UTF-8 and latin1.
#     	</longdescription>
#     </pkgmetadata>
#
# * Send an email to vim@gentoo.org to let us know.
#
# Don't forget to update your package as necessary.
#
# If there isn't an upstream-provided pregenerated spell file for your language
# yet, read :help spell.txt from inside vim for instructions on how to create
# spell files. It's best to let upstream know if you've generated spell files
# for another language rather than keeping them Gentoo-specific.

EXPORT_FUNCTIONS src_install pkg_postinst

SRC_URI="mirror://gentoo/${P}.tar.bz2"
SLOT="0"

# @ECLASS-VARIABLE: VIM_SPELL_LANGUAGE
# @DESCRIPTION:
# This variable defines the language for the spell package being
# installed.
# The default value is "English".
: ${VIM_SPELL_LANGUAGE:="English"}

# @ECLASS-VARIABLE: VIM_SPELL_LOCALE
# @INTERNAL
# @DESCRIPTION:
# This variable defines the locale for the current ebuild.
# The default value is ${PN} stripped of the "vim-spell-" string.
: ${VIM_SPELL_LOCALE:="${PN/vim-spell-/}"}

# @ECLASS-VARIABLE: VIM_SPELL_DIRECTORY
# @INTERNAL
# @DESCRIPTION:
# This variable defines the path to Vim spell files.
: ${VIM_SPELL_DIRECTORY:="${EPREFIX}/usr/share/vim/vimfiles/spell/"}

# @ECLASS-VARIABLE: DESCRIPTION
# @DESCRIPTION:
# This variable defines the DESCRIPTION for Vim spell ebuilds.
: ${DESCRIPTION:="vim spell files: ${VIM_SPELL_LANGUAGE} (${VIM_SPELL_LOCALE})"}

# @ECLASS-VARIABLE: HOMEPAGE
# @DESCRIPTION:
# This variable defines the HOMEPAGE for Vim spell ebuilds.
: ${HOMEPAGE:="https://www.vim.org"}

# @FUNCTION: vim-spell_src_install
# @DESCRIPTION:
# This function installs Vim spell files.
vim-spell_src_install() {
	dodir "${VIM_SPELL_DIRECTORY}"
	insinto "${VIM_SPELL_DIRECTORY}"

	local had_spell_file=
	local f
	for f in *.spl; do
		if [[ -f "${f}" ]]; then
			doins "${f}"
			had_spell_file="yes"
		fi
	done

	for f in *.sug; do
		if [[ -f "${f}" ]]; then
			doins "${f}"
		fi
	done

	for f in README*; do
		dodoc "${f}"
	done

	[[ -z "${had_spell_file}" ]] && die "Didn't install any spell files?"
}

# @FUNCTION: vim-spell_pkg_postinst
# @DESCRIPTION:
# This function displays installed Vim spell files.
vim-spell_pkg_postinst() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EROOT="${ROOT}"
	echo
	elog "To enable ${VIM_SPELL_LANGUAGE} spell checking, use"
	elog "    :setlocal spell spelllang=${VIM_SPELL_LOCALE}"
	echo
	elog "The following (Vim internal, not file) encodings are supported for"
	elog "this language:"
	local f enc
	for f in "${EROOT}${VIM_SPELL_DIRECTORY}/${VIM_SPELL_LOCALE}".*.spl; do
		enc="${f##*/${VIM_SPELL_LOCALE}.}"
		enc="${enc%.spl}"
		[[ -z "${enc}" ]] && continue
		elog "    ${enc}"
	done
	echo
	elog "For further documentation, use:"
	elog "    :help spell"
	echo
}
