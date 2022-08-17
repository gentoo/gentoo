# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

DISTUTILS_USE_SETUPTOOLS=no

inherit desktop distutils-r1 optfeature xdg-utils

# Tag isn't provided this time
COMMIT_SHA="cdfdf8c593f98863b4034b38001c71bc9fb970c3"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~arm64 ~x86"
	SRC_URI="https://foss.heptapod.net/mercurial/${PN}/thg/-/archive/${COMMIT_SHA}/thg-${COMMIT_SHA}.tar.gz -> ${P}.tar.gz"
	HG_DEPEND=">=dev-vcs/mercurial-5.9[${PYTHON_USEDEP}]
		<dev-vcs/mercurial-6.2[${PYTHON_USEDEP}]"
	S="${WORKDIR}/thg-${COMMIT_SHA}"
else
	inherit mercurial
	EHG_REPO_URI="https://foss.heptapod.net/mercurial/${PN}/thg"
	EHG_REVISION="stable"
	HG_DEPEND=">=dev-vcs/mercurial-5.9[${PYTHON_USEDEP}]"
fi

DESCRIPTION="Set of graphical tools for Mercurial"
HOMEPAGE="https://tortoisehg.bitbucket.io/"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	${HG_DEPEND}
	dev-python/iniparse[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/PyQt5[network,svg,${PYTHON_USEDEP}]
	>=dev-python/qscintilla-python-2.9.4[qt5(+),${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
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
	distutils-r1_python_prepare_all
}

python_test() {
	${EPYTHON} tests/run-tests.py -m 'not largefiles' --doctest-modules tests || die
	${EPYTHON} tests/run-tests.py -m largefiles tests || die
}

python_install_all() {
	distutils-r1_python_install_all
	dodoc doc/ReadMe*.txt doc/TODO contrib/mergetools.rc
	newicon -s scalable icons/scalable/apps/thg.svg thg_logo.svg
	domenu contrib/thg.desktop
}

pkg_postinst() {
	xdg_icon_cache_update
	elog "When startup of ${PN} fails with an API version mismatch error"
	elog "between dev-python/sip and dev-python/PyQt5 please rebuild"
	elog "dev-python/qscintilla-python."

	optfeature "the core git extension support" dev-python/pygit2
}

pkg_postrm() {
	xdg_icon_cache_update
}
