# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=25

inherit elisp

DESCRIPTION="GraphQL utilities"
HOMEPAGE="https://github.com/vermiculus/graphql.el"
SRC_URI="https://github.com/vermiculus/graphql.el/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}.el-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"

# Tries to download emake tool on the fly
RESTRICT="test"

src_prepare() {
	# Avoid examples which would require circular dependencies
	rm -f examples.el || die

	default
}
