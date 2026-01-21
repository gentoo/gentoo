# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Major mode for password-store"
HOMEPAGE="https://github.com/volrath/password-store-otp.el"
SRC_URI="https://github.com/volrath/${PN}.el/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}.el-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-admin/pass[emacs]
	app-emacs/s"
RDEPEND="${BDEPEND}
	app-admin/pass-otp"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

# tests are for old buttercup without lexical binding
#elisp-enable-tests buttercup tests
