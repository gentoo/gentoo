# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Testing framework for infrastructure software"
HOMEPAGE="https://github.com/jmmv/kyua"
SRC_URI="https://github.com/jmmv/kyua/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~x86"
IUSE="test"

# Tests fail
RESTRICT="test"

RDEPEND="
	dev-db/sqlite:3
	dev-lua/lutok
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-libs/atf )
"
