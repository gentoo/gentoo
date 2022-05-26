# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=179cc126b363f72ca12fab1e0dc462ce0ee79742

inherit elisp

DESCRIPTION="Show tooltip at point"
HOMEPAGE="https://github.com/pitkali/pos-tip/"
SRC_URI="https://github.com/pitkali/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
