# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_SINGLE_IMPL=1
PYTHON_REQ_USE="tk"

inherit distutils-r1 desktop

MY_PN=PySolFC
CARD_BASE="${MY_PN}-Cardsets"
CARD_BASEV="${CARD_BASE}-2.0"
CARD_BASE_MINV="${CARD_BASE}--Minimal-2.0.1"
SF_CARD_BASE="mirror://sourceforge/${PN}/${CARD_BASE}"

DESCRIPTION="An exciting collection of more than 1000 solitaire card games"
HOMEPAGE="https://pysolfc.sourceforge.net/"
SRC_URI="https://github.com/shlomif/${MY_PN}/archive/${P}.tar.gz
	extra-cardsets? ( ${SF_CARD_BASE}/${CARD_BASEV}/${CARD_BASEV}.tar.bz2 )
	!extra-cardsets? ( ${SF_CARD_BASE}/minimal/${CARD_BASE_MINV}.tar.xz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="extra-cardsets minimal +sound"

S="${WORKDIR}/${MY_PN}-${P}"

RDEPEND="
	dev-python/random2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!minimal? (
		dev-python/pillow[tk,${PYTHON_USEDEP}]
		dev-tcltk/tktable
	)
	sound? (
		dev-python/pygame[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/${PN}-gentoo.patch" #591904
	"${FILESDIR}/${PN}-locales.patch"
)

python_prepare_all() {
	sed -i \
		-e "/pysol.desktop/d" \
		-e "s:share/icons:share/pixmaps:" \
		-e "s:data_dir =.*:data_dir = \'/usr/share/${PN}\':" \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	pushd html-src > /dev/null || die "html-src not found"
	PYTHONPATH=.. "${EPYTHON}" gen-html.py || die "gen-html failed"
	mv images html/ || die "mv images failed"
	popd > /dev/null
}

python_install_all() {
	make_desktop_entry pysol.py "PySol Fan Club Edition" pysol02

	if use extra-cardsets; then
		insinto /usr/share/${PN}
		doins -r "${WORKDIR}"/"${CARD_BASEV}"/*
	else
		# upstream bug #89
		# repo does not contain minimal cardsets in archive
		insinto /usr/share/${PN}
		doins -r "${WORKDIR}"/"${CARD_BASE_MINV}"/*
	fi

	dosym ../doc/${PF}/html /usr/share/${PN}/html

	doman docs/*.6
	DOCS=( README.md AUTHORS.md docs/README docs/README.SOURCE )
	HTML_DOCS=( html-src/html/. )
	distutils-r1_python_install_all
}
