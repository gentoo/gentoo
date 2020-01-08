# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )
inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/diafygi/${PN}.git"
	KEYWORDS="amd64"
else
	SRC_URI="https://github.com/diafygi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

DESCRIPTION="A tiny, auditable script for Let's Encrypt's ACME Protocol"
HOMEPAGE="https://github.com/diafygi/acme-tiny"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"
RDEPEND="dev-libs/openssl:0"

pkg_setup() {
	if [[ ${PV} != 9999 ]]; then
		export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
	fi
}

src_prepare() {
	sed -i 's|#!/usr/bin/sh|#!/bin/sh|g' README.md || die

	distutils-r1_src_prepare
}

pkg_postinst() {
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "$v" "-lt" "4.0.3" || ver_test "$v" "-ge" "9999"; then
			einfo "The --account-email flag has been changed to --contact and"
			einfo "has different syntax."
			einfo "Please update your scripts accordingly"
		fi
	done
}
