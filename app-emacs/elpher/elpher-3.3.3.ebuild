# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == 3.3.3 ]] && COMMIT=ab75cff
NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Practical and friendly Gopher and Gemini client for GNU Emacs"
HOMEPAGE="https://thelambdalab.xyz/elpher/"
SRC_URI="https://thelambdalab.xyz/gitweb/index.cgi?p=${PN}.git;a=snapshot;h=${COMMIT};sf=tgz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( ISSUES.org README )
ELISP_REMOVE="elpher-pkg.el"
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"
