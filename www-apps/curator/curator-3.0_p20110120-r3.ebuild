# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Gallery generator"
HOMEPAGE="http://furius.ca/curator/"
SRC_URI="mirror://gentoo/curator-3.0_pf078f1686a78.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pillow[${PYTHON_MULTI_USEDEP}]
	')
	virtual/imagemagick-tools"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S="${WORKDIR}/curator-3.0_pf078f1686a78"

src_compile() {
	python_fix_shebang hs/curator-hs
}

src_install() {
	dobin hs/curator-hs
	insinto /usr/share/curator
	doins -r hs
}
