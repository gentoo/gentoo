# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.2

inherit elisp

DESCRIPTION="Simple wrapper around asynchronous processes"
HOMEPAGE="https://github.com/Alexander-Miller/pfuture/"
SRC_URI="https://github.com/Alexander-Miller/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
