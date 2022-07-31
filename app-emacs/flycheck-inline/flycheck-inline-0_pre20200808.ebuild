# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=25
MY_COMMIT="8e00b4c5951a9515a450a14aefe92e9f6ddcfbde"

inherit elisp

DESCRIPTION="Display Flycheck errors inline"
HOMEPAGE="https://github.com/flycheck/flycheck-inline"
SRC_URI="https://github.com/flycheck/flycheck-inline/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x64-macos"

SITEFILE="50${PN}-gentoo.el"

DEPEND="app-emacs/flycheck"
RDEPEND="${DEPEND}"
