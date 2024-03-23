# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="tk"
inherit distutils-r1 xdg

MY_PN="PySolFC"
MY_P="${MY_PN}-${PV}"
PS_CARD_P="${MY_PN}-Cardsets-2.2"
PS_CARD_MIN_P="${MY_PN}-Cardsets--Minimal-2.2.0"

DESCRIPTION="Exciting collection of more than 1000 solitaire card games"
HOMEPAGE="https://pysolfc.sourceforge.io/"
SRC_URI="mirror://sourceforge/pysolfc/${MY_P}.tar.xz
	extra-cardsets? ( mirror://sourceforge/pysolfc/${PS_CARD_P}.tar.bz2 )
	!extra-cardsets? ( mirror://sourceforge/pysolfc/${PS_CARD_MIN_P}.tar.xz )"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+ GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="extra-cardsets minimal +sound"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/configobj[${PYTHON_USEDEP}]
		dev-python/pysol-cards[${PYTHON_USEDEP}]
		dev-python/random2[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		sound? ( dev-python/pygame[${PYTHON_USEDEP}] )
		!minimal? ( dev-python/pillow[jpeg,tk,${PYTHON_USEDEP}] )')
	!minimal? ( dev-tcltk/tktable )"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# make pip check happier, pycotap is not needed
	sed -i "/'pycotap'/d" setup.py || die

	if use extra-cardsets; then
		find ../${PS_CARD_P} -type d -name .thumbnails -exec rm -r {} + || die
	fi
}

python_install_all() {
	local DOCS=( AUTHORS.md NEWS.asciidoc README.md )
	distutils-r1_python_install_all

	doman docs/pysol{,fc}.6

	insinto /usr/share/${MY_PN}
	doins -r ../$(usex extra-cardsets ${PS_CARD_P} ${PS_CARD_MIN_P})/.

	# html files are used at runtime, keep at default location
	dosym -r /usr/share/{${MY_PN},doc/${PF}}/html

	# russian translation is not currently displaying right
	# https://forums.gentoo.org/viewtopic-t-1142910.html
	rm "${ED}"/usr/share/locale/ru/LC_MESSAGES/pysol.mo || die
}
