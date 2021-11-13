# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_SINGLE_IMPL=1
PYTHON_REQ_USE="tk"
inherit distutils-r1 xdg

MY_PN="PySolFC"
MY_P="${MY_PN}-${PV}"
PS_CARD_P="${MY_PN}-Cardsets-2.1PRE"
PS_CARD_MIN_P="${MY_PN}-Cardsets--Minimal-2.0.2"

DESCRIPTION="Exciting collection of more than 1000 solitaire card games"
HOMEPAGE="https://pysolfc.sourceforge.io/"
SRC_URI="mirror://sourceforge/pysolfc/${MY_P}.tar.xz
	extra-cardsets? ( mirror://sourceforge/pysolfc/${PS_CARD_P}.tar.bz2 )
	!extra-cardsets? ( mirror://sourceforge/pysolfc/${PS_CARD_MIN_P}.tar.xz )"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+ GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="extra-cardsets minimal +sound"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/configobj[${PYTHON_USEDEP}]
		dev-python/pysol_cards[${PYTHON_USEDEP}]
		dev-python/random2[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		!minimal? (
			dev-python/pillow[jpeg,tk,${PYTHON_USEDEP}]
			dev-tcltk/tktable
		)
		sound? ( dev-python/pygame[${PYTHON_USEDEP}] )
	')"

distutils_enable_tests unittest

python_install_all() {
	local DOCS=( AUTHORS.md NEWS.asciidoc README.md )
	distutils-r1_python_install_all

	doman docs/pysol{,fc}.6

	insinto /usr/share/${MY_PN}
	doins -r ../$(usex extra-cardsets ${PS_CARD_P} ${PS_CARD_MIN_P})/.

	# html files are used at runtime, keep at default location
	dosym -r /usr/share/{${MY_PN},doc/${PF}}/html

	# russion translation is currently not displaying right
	rm "${ED}"/usr/share/locale/ru/LC_MESSAGES/pysol.mo || die
}
