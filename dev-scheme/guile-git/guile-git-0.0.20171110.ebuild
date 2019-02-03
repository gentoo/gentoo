# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Guile bindings of git"
HOMEPAGE="https://gitlab.com/guile-git/guile-git"
SRC_URI="https://dev.gentoo.org/~slyfox/distfiles/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-scheme/guile-2.0.11:=
	dev-scheme/bytestructures
	dev-libs/libgit2:=
"
DEPEND="${RDEPEND}"
