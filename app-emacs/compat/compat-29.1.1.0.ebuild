# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Compatibility libraries for Emacs"
HOMEPAGE="https://github.com/emacs-compat/compat/
	https://git.sr.ht/~pkal/compat/"
SRC_URI="https://github.com/emacs-compat/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

BDEPEND="sys-apps/texinfo"

ELISP_TEXINFO="${PN}.texi"

src_compile() {
	emake compile ${PN}.info
}

src_test() {
	local has_json="$("${EMACS}" ${EMACSFLAGS} --eval "(princ (fboundp 'json-parse-string))")"
	if [[ "${has_json}" != t ]] ; then
		local line
		while read line ; do
			ewarn "${line}"
		done <<-EOF
		Your current Emacs version does not support native JSON parsing,
		which is required for running tests of ${CATEGORY}/${PN}.
		Emerge >=app-editors/emacs-27 with USE="json" and use "eselect emacs"
		to select that version.
		EOF
	else
		emake test
	fi
}
