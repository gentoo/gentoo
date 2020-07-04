# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit python-utils-r1 vcs-clean

COMMIT="9d711f40638202b02f2154d7f05ea35088ff9388"

DESCRIPTION="MathJax documentation"
HOMEPAGE="https://www.mathjax.org/"
SRC_URI="https://github.com/mathjax/MathJax-docs/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-python/sphinx"

S=${WORKDIR}/MathJax-docs-${COMMIT}

src_prepare() {
	default
	egit_clean
}

src_compile() {
	build_sphinx "${S}"
}

src_install() {
	local DOCS=( README.md )
	default
	dosym ${P} /usr/share/doc/${PN}-${SLOT}
}
