# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )
PYTHON_REQ_USE="tk"

inherit eutils distutils-r1

MY_PN=PySolFC

DESCRIPTION="An exciting collection of more than 1000 solitaire card games"
HOMEPAGE="http://pysolfc.sourceforge.net/"
SRC_URI="https://github.com/shlomif/${MY_PN}/archive/${P}.tar.gz
	extra-cardsets? ( mirror://sourceforge/${PN}/archive/${P}/${MY_PN}-Cardsets-2.0.tar.bz2 )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="extra-cardsets minimal +sound"

S=${WORKDIR}/${MY_PN}-${P}

DEPEND="dev-python/six"
RDEPEND="${DEPEND}
	python_targets_python3_5? ( dev-python/random2[python_targets_python3_5] )
	python_targets_python3_6? ( dev-python/random2[python_targets_python3_6] )
	!minimal? ( dev-python/pillow[tk,${PYTHON_USEDEP}]
		dev-tcltk/tktable )
	sound? ( dev-python/pygame[${PYTHON_USEDEP}] )"

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
		doins -r "${WORKDIR}"/${MY_PN}-Cardsets-2.0/*
	fi

	dosym /usr/share/doc/${PF}/html /usr/share/${PN}/html

	doman docs/*.6
	DOCS=( README.md AUTHORS docs/README docs/README.SOURCE )
	HTML_DOCS=( html-src/html/. )
	distutils-r1_python_install_all
}
