# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=f117f2f
NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Practical and friendly Gopher and Gemini client for GNU Emacs"
HOMEPAGE="https://thelambdalab.xyz/elpher/"
SRC_URI="https://thelambdalab.xyz/gitweb/index.cgi?p=${PN}.git;a=snapshot;h=${H};sf=tgz
			-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( ISSUES.org README )
ELISP_REMOVE="elpher-pkg.el"
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"
