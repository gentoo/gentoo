# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=948cf2faa10e085bda3739034ca5ea1912893433
NEED_EMACS=24.1

inherit elisp

DESCRIPTION="Async support for ERT"
HOMEPAGE="https://github.com/rejeep/ert-async.el/"
SRC_URI="https://github.com/rejeep/${PN}.el/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
