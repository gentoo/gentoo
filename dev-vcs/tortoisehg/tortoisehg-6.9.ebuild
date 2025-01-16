# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit desktop distutils-r1 optfeature xdg-utils

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~arm64 ~x86"
	SRC_URI="https://foss.heptapod.net/mercurial/${PN}/thg/-/archive/${PV}/thg-${PV}.tar.gz -> ${P}.tar.gz"
	HG_DEPEND=">=dev-vcs/mercurial-6.3[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-vcs/mercurial-6.9[${PYTHON_USEDEP}]' python3_13 )
		<dev-vcs/mercurial-6.10[${PYTHON_USEDEP}]"
	S="${WORKDIR}/thg-${PV}"
else
	inherit mercurial
	EHG_REPO_URI="https://foss.heptapod.net/mercurial/${PN}/thg"
	EHG_REVISION="stable"
	HG_DEPEND=">=dev-vcs/mercurial-6.3[${PYTHON_USEDEP}]"
fi

DESCRIPTION="Set of graphical tools for Mercurial"
HOMEPAGE="https://tortoisehg.bitbucket.io/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="${HG_DEPEND}
	dev-python/iniparse[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pyqt6[network,svg,${PYTHON_USEDEP}]
	>=dev-python/qscintilla-2.14.1-r1[qt6(+),${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx doc/source

python_prepare_all() {
	# Remove file that collides with >=mercurial-4.0 (bug #599266).
	rm "${S}"/hgext3rd/__init__.py || die "can't remove /hgext3rd/__init__.py"

	sed -i -e 's:share/doc/tortoisehg:share/doc/'"${PF}"':' setup.py || die
	sed -i -e '/^testedwith/s/6.8/6.8 6.9/' tortoisehg/util/hgversion.py || die
	export THG_QT_API=PyQt6
	distutils-r1_python_prepare_all
}

python_test() {
	${EPYTHON} tests/run-tests.py -m 'not largefiles' --disable-pytest-warnings --doctest-modules tests || die "Tests failed with ${EPYTHON}"
	${EPYTHON} tests/run-tests.py -m largefiles --disable-pytest-warnings tests || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	export THG_QT_API=PyQt6
	distutils-r1_python_install_all
	dodoc doc/ReadMe*.txt doc/TODO contrib/mergetools.rc
	newicon -s scalable icons/scalable/apps/thg.svg thg_logo.svg
	domenu contrib/thg.desktop
}

pkg_postinst() {
	xdg_icon_cache_update
	elog "When startup of ${PN} fails with an API version mismatch error"
	elog "between dev-python/sip and dev-python/pyqt6 please rebuild"
	elog "dev-python/qscintilla."

	optfeature "the core git extension support" dev-python/pygit2
}

pkg_postrm() {
	xdg_icon_cache_update
}
