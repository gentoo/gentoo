# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Fast, simple packet creation / parsing"
HOMEPAGE="https://github.com/kbandla/dpkt"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

DOCS=( AUTHORS CHANGES HACKING )

python_test() {
	"${PYTHON}" tests/test-perf2.py || die
}

src_install() {
	distutils-r1_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
