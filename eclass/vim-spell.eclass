# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# Original Author: Ciaran McCreesh <ciaranm@gentoo.org>
# Maintainers:     Vim Herd <vim@gentoo.org>
# Purpose:         Simplify installing spell files for vim7
#

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
# * (for now) Add your spell file to package.mask next to the other vim7
#   things. The vim herd will handle unmasking your spell packages when vim7
#   comes out of package.mask.
#
# * Create the app-vim/vim-spell-${CODE} package. You should base your ebuild
#   upon app-vim/vim-spell-en. You will need to change VIM_SPELL_LANGUAGE,
#   KEYWORDS and LICENSE. Check the license carefully! The README will tell
#   you what it is.
#
# * Don't forget metadata.xml. You should list vim as the herd, and yourself
#   as the maintainer (there is no need to join the vim herd just for spell
#   files):
#
#     <?xml version="1.0" encoding="UTF-8"?>
#     <!DOCTYPE pkgmetadata SYSTEM "https://www.gentoo.org/dtd/metadata.dtd">
#     <pkgmetadata>
#     	<herd>vim</herd>
#     	<maintainer>
#     		<email>your-name@gentoo.org</email>
#     	</maintainer>
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
# yet, read :help spell.txt from inside vim7 for instructions on how to create
# spell files. It's best to let upstream know if you've generated spell files
# for another language rather than keeping them Gentoo-specific.

inherit eutils

EXPORT_FUNCTIONS src_install pkg_postinst

IUSE=""
DEPEND="|| ( >=app-editors/vim-7_alpha
	>=app-editors/gvim-7_alpha )"
RDEPEND="${DEPEND}"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
SLOT="0"

if [[ -z "${VIM_SPELL_CODE}" ]] ; then
	VIM_SPELL_CODE="${PN/vim-spell-/}"
fi

DESCRIPTION="vim spell files: ${VIM_SPELL_LANGUAGE} (${VIM_SPELL_CODE})"

if [[ -z "${HOMEPAGE}" ]] ; then
	HOMEPAGE="http://www.vim.org/"
fi

vim-spell_src_install() {
	target="/usr/share/vim/vimfiles/spell/"
	dodir "${target}"
	insinto "${target}"

	had_spell_file=
	for f in *.spl ; do
		if [[ -f "${f}" ]]; then
			doins "${f}"
			had_spell_file="yes"
		fi
	done

	for f in *.sug ; do
		if [[ -f "${f}" ]]; then
			doins "${f}"
		fi
	done

	for f in README* ; do
		dodoc "${f}"
	done

	[[ -z "${had_spell_file}" ]] && die "Didn't install any spell files?"
}

vim-spell_pkg_postinst() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EROOT="${ROOT}"
	target="/usr/share/vim/vimfiles/spell/"
	echo
	elog "To enable ${VIM_SPELL_LANGUAGE} spell checking, use"
	elog "    :setlocal spell spelllang=${VIM_SPELL_CODE}"
	echo
	elog "The following (Vim internal, not file) encodings are supported for"
	elog "this language:"
	for f in "${EROOT}/${target}/${VIM_SPELL_CODE}".*.spl ; do
		enc="${f##*/${VIM_SPELL_CODE}.}"
		enc="${enc%.spl}"
		[[ -z "${enc}" ]] && continue
		elog "    ${enc}"
	done
	echo
	elog "For further documentation, use:"
	elog "    :help spell"
	echo
	epause
}
