# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Practical and friendly Gopher and Gemini client for GNU Emacs"
HOMEPAGE="https://thelambdalab.xyz/elpher/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="git://thelambdalab.xyz/${PN}.git"
else
	if [[ "${PV}" == 3.6.0 ]] ; then
		COMMIT=56bc74e
		SRC_URI="https://thelambdalab.xyz/gitweb/index.cgi?p=${PN}.git;a=snapshot;h=${COMMIT};sf=tgz
			-> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${COMMIT}"
	else
		die "could not generate SRC_URI"
	fi

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

ELISP_REMOVE="
	elpher-pkg.el
"

DOCS=( ISSUES.org README )
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"
