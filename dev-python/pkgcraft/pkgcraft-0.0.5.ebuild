# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Python bindings for pkgcraft"
HOMEPAGE="
	https://pypi.org/project/pkgcraft/
	https://github.com/pkgcraft/pkgcraft-python
"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcraft/pkgcraft-python"
	inherit git-r3

	PKGCRAFT_VERSION_MAX="9999"
	PKGCRAFT_VERSION_MIN="9999"
else
	SRC_URI="https://github.com/pkgcraft/pkgcraft-python/releases/download/v${PV}/${P/-python}.tar.gz"
	S="${WORKDIR}"/${P/-python}

	KEYWORDS="~amd64 ~arm64"

	PKGCRAFT_VERSION_MAX="9999"
	PKGCRAFT_VERSION_MIN="0.0.6"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+examples"

RDEPEND="
	<sys-libs/pkgcraft-${PKGCRAFT_VERSION_MAX}
	>=sys-libs/pkgcraft-${PKGCRAFT_VERSION_MIN}:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/cython
	dev-python/setuptools-scm
	virtual/pkgconfig
"

distutils_enable_tests pytest

python_prepare_all() {
	if [[ ${PV} != 9999 ]] ; then
		local actual_pkgcraft_min=$(sed -En '/^MIN_VERSION =/{s/[^0-9.]//gp}' setup.py || die)
		if [[ ${actual_pkgcraft_min} != ${PKGCRAFT_VERSION_MIN} ]] ; then
			eerror "Expected minimum pkgcraft-c version: ${PKGCRAFT_VERSION_MIN}"
			eerror "Actual minimum pkgcraft-c version: ${actual_pkgcraft_min}"
			die "Mismatch between setup.py's MIN_VERSION and ebuild!"
		fi
	fi

	distutils-r1_python_prepare_all
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

python_install() {
	# Conditional because these aren't installed officially right now
	# and the naming is just for convenience.
	if use examples ; then
		while IFS= read -r -d '' file ; do
			python_newexe "${S}"/examples/${file##*/} pkgcraft-${file##*/}
		done < <(find "${S}"/examples -type f -executable -print0 || die)
	fi

	distutils-r1_python_install
}
