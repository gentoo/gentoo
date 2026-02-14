# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=948cf2faa10e085bda3739034ca5ea1912893433

inherit elisp

DESCRIPTION="Async support for ERT"
HOMEPAGE="https://github.com/rejeep/ert-async.el/"
SRC_URI="https://github.com/rejeep/${PN}.el/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc64 ~riscv ~sparc x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
