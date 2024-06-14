# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..13} )

inherit distutils-r1

DESCRIPTION="Paperwork plugins"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork"
SRC_URI="https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/archive/${PV}/paperwork-${PV}.tar.bz2"
S=${WORKDIR}/paperwork-${PV}/${PN}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-text/openpaperwork-core[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	gui-libs/libhandy
	x11-libs/gtk+:3[introspection]"
DEPEND="${RDEPEND}"
BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]
	sys-apps/which
	sys-devel/gettext"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_compile() {
	emake l10n_compile

	distutils-r1_python_compile
}
