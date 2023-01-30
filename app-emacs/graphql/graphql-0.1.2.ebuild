# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25
[[ "${PV}" == 0.1.2 ]] && COMMIT=67237f284f2dfb94f3cfba672ff64a37e1cb860f

inherit elisp

DESCRIPTION="GraphQL utilities"
HOMEPAGE="https://github.com/vermiculus/graphql.el/"
SRC_URI="https://github.com/vermiculus/graphql.el/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"

# Tries to download emake tool on the fly
RESTRICT="test"

src_prepare() {
	# Avoid examples which would require circular dependencies
	rm -f ${PN}-examples.el || die

	default
}
