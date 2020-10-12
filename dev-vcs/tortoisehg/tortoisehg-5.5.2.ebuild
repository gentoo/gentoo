# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_USE_SETUPTOOLS=no

inherit desktop distutils-r1 xdg-utils

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~arm64 ~x86"
	SRC_URI="https://www.mercurial-scm.org/release/tortoisehg/targz/${P}.tar.gz"
	HG_DEPEND=">=dev-vcs/mercurial-5.4
		<dev-vcs/mercurial-5.6"
else
	inherit mercurial
	EHG_REPO_URI="https://foss.heptapod.net/mercurial/tortoisehg/thg"
	EHG_REVISION="stable"
	HG_DEPEND=">=dev-vcs/mercurial-5.4"
fi

DESCRIPTION="Set of graphical tools for Mercurial"
HOMEPAGE="https://tortoisehg.bitbucket.io/"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	${HG_DEPEND}
	dev-python/iniparse[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/PyQt5[network,svg,${PYTHON_USEDEP}]
	>=dev-python/qscintilla-python-2.9.4[qt5(+),${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_sphinx doc/source

python_prepare_all() {
	# Remove file that collides with >=mercurial-4.0 (bug #599266).
	rm "${S}"/hgext3rd/__init__.py || die "can't remove /hgext3rd/__init__.py"
	distutils-r1_python_prepare_all
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
}

pkg_postrm() {
	xdg_icon_cache_update
}
