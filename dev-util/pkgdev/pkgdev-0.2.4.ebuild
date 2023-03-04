# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 optfeature

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/pkgcore/pkgdev.git
		https://github.com/pkgcore/pkgdev.git"
	inherit git-r3
else
	inherit pypi
	KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~x64-macos"
fi

DESCRIPTION="Collection of tools for Gentoo development"
HOMEPAGE="https://github.com/pkgcore/pkgdev"

LICENSE="BSD MIT"
SLOT="0"

if [[ ${PV} == *9999 ]] ; then
	RDEPEND="
		~dev-python/snakeoil-9999[${PYTHON_USEDEP}]
		~dev-util/pkgcheck-9999[${PYTHON_USEDEP}]
		~sys-apps/pkgcore-9999[${PYTHON_USEDEP}]
	"
else
	RDEPEND="
		>=dev-python/snakeoil-0.10.3[${PYTHON_USEDEP}]
		>=dev-util/pkgcheck-0.10.16[${PYTHON_USEDEP}]
		>=sys-apps/pkgcore-0.12.16[${PYTHON_USEDEP}]
	"
fi

RDEPEND+="
	dev-vcs/git
"
BDEPEND="
	>=dev-python/flit_core-3.8[${PYTHON_USEDEP}]
	test? (
		x11-misc/xdg-utils
	)
"

distutils_enable_sphinx doc \
	">=dev-python/snakeoil-0.10.3" \
	dev-python/tomli
distutils_enable_tests pytest

python_compile_all() {
	use doc && emake PYTHON="${EPYTHON}" man

	sphinx_compile_all # HTML pages only
}

python_install_all() {
	# If USE=doc, there'll be newly generated docs which we install instead.
	if use doc || [[ ${PV} != *9999 ]]; then
		doman build/sphinx/man/*
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "sending email support" x11-misc/xdg-utils
}
