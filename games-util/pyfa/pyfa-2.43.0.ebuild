# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{8..9} )
PYTHON_REQ_USE="sqlite"

inherit desktop edos2unix python-single-r1 xdg

DESCRIPTION="Python Fitting Assistant - a ship fitting application for EVE Online"
HOMEPAGE="https://github.com/pyfa-org/Pyfa"

LICENSE="GPL-3+ all-rights-reserved"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/pyfa-org/Pyfa.git"
	inherit git-r3
else
	SRC_URI="https://github.com/pyfa-org/Pyfa/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/Pyfa-${PV}"
fi

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="mirror bindist"

DEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cryptography-2.3[${PYTHON_USEDEP}]
		>=dev-python/logbook-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.3.23[${PYTHON_USEDEP}]
		>=dev-python/wxpython-4.0.6[webkit,${PYTHON_USEDEP}]
	')
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/beautifulsoup4-4.6.0[${PYTHON_USEDEP}]
		>=dev-python/markdown2-2.3.5[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.19.2[${PYTHON_USEDEP}]
		>=dev-python/packaging-16.8[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		>=dev-python/python-jose-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/requests-cache-0.8.1[${PYTHON_USEDEP}]
		>=dev-python/roman-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.2.2[wxwidgets,${PYTHON_USEDEP}]
	')"
BDEPEND="app-arch/zip"

PATCHES=(
	# fix import path in the main script for systemwide installation
	"${FILESDIR}/${PN}-2.9.3-import-pyfa.patch"
)

src_prepare() {
	# get rid of CRLF line endings introduced in 1.1.10 so patches work
	edos2unix config.py pyfa.py gui/bitmap_loader.py service/settings.py

	default

	# make python recognize pyfa as a package
	touch __init__.py || die

	sed -e "s:%%SITEDIR%%:$(python_get_sitedir):" \
		-e "s:%%EPREFIX%%:${EPREFIX}:" \
		"${FILESDIR}/configforced-1.15.1.py" > configforced.py || die
	sed -e "s:%%SITEDIR%%:$(python_get_sitedir):" \
		pyfa.py > pyfa || die
}

src_install() {
	python_moduleinto ${PN}
	python_domodule eos gui service utils graphs
	python_domodule config*.py __init__.py version.yml configforced.py db_update.py
	python_doscript pyfa

	insinto /usr/share/${PN}

	einfo "Creating database ..."
	${EPYTHON} ./db_update.py || die
	doins eve.db

	einfo "Compressing images ..."
	pushd imgs > /dev/null || die
	zip -r imgs.zip * || die "zip failed"
	doins imgs.zip
	popd > /dev/null || die

	dodoc README.md
	doicon -s 32 imgs/gui/pyfa.png
	newicon -s 64 imgs/gui/pyfa64.png pyfa.png
	domenu "${FILESDIR}/${PN}.desktop"
}
