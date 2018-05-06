# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/diafygi/${PN}.git"
	KEYWORDS=""
elif [[ ${PV} =~ 0_p* ]]; then
	HASH="4ed13950c0a9cf61f1ca81ff1874cde1cf48ab32"
	SRC_URI="https://github.com/diafygi/${PN}/archive/${HASH}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${HASH}"
else
	SRC_URI="https://github.com/diafygi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A tiny, auditable script for Let's Encrypt's ACME Protocol"
HOMEPAGE="https://github.com/diafygi/acme-tiny"

LICENSE="MIT"
SLOT="0"

IUSE="minimal"

DEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"
RDEPEND="dev-libs/openssl:0"

PATCHES=( "${FILESDIR}/${PN}-PR50-setup.py.patch" )

pkg_setup() {
	if [[ ${PV} != 9999 ]]; then
		export SETUPTOOLS_SCM_PRETEND_VERSION="0.1.dev79+n${HASH:0:7}.d$(date +%Y%m%d)"
	fi
}

src_prepare() {
	if ! use minimal; then
		PATCHES+=(
			"${FILESDIR}/${PN}-PR87-readmefix.patch"
			"${FILESDIR}/${PN}-PR101-contactinfo.patch"
		)
	fi
	distutils-r1_src_prepare
}
