# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Backend part of Paperwork (Python API, no UI)"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork"
# Update from release hash at:
# https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/tags
REL_HASH="0bea4054"
SRC_URI="https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/archive/${PV}/paperwork-${PV}.tar.bz2
	https://download.openpaper.work/data/paperwork/master_${REL_HASH}/data.tar.gz -> paperwork-data-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-text/openpaperwork-core[${PYTHON_USEDEP}]
	app-text/openpaperwork-gtk[${PYTHON_USEDEP}]
	app-text/poppler[introspection]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pycountry[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/scikit-learn[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	dev-python/whoosh[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	sys-apps/which
	sys-devel/gettext
	test? (
		dev-python/libpillowfight[${PYTHON_USEDEP}]
		media-libs/libinsane
	)
"
S=${WORKDIR}/paperwork-${PV}/${PN}

distutils_enable_tests unittest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_prepare() {
	default
	cd "${WORKDIR}"/paperwork-${PV} || die
	eapply "${FILESDIR}"/${P}-cairo_workaround.patch
}

python_compile() {
	emake l10n_compile

	distutils-r1_python_compile
}
