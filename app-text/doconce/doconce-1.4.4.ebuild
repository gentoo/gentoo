# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="A markdown-like langauge to generate docs in html, LaTeX, and many other formats"
HOMEPAGE="https://github.com/hplgit/doconce/ https://pypi.org/project/Doconce/"
SRC_URI="https://dev.gentoo.org/~grozin/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
IUSE="doc"
KEYWORDS="~amd64 ~x86"
RDEPEND="dev-python/future[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_install() {
	default
	if use doc; then
		sed -e "s|http://hplgit.github.io/doconce/doc|file:///usr/share/doc/${PF}|g" -i doc/web/index.html
		docompress -x /usr/share/doc
		dodoc -r doc/web doc/pub
	fi
}
