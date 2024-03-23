# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python{3_10,3_11,3_12} )

DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1

SRC_URI="https://github.com/diafygi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="A tiny, auditable script for Let's Encrypt's ACME Protocol"
HOMEPAGE="https://github.com/diafygi/acme-tiny"

LICENSE="MIT"
SLOT="0"

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"
RDEPEND="dev-libs/openssl:0"

# Tests require a local ACME server to be set up.
RESTRICT="test"

pkg_setup() {
	export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
}

src_prepare() {
	sed -i 's|#!/usr/bin/sh|#!/bin/sh|g' README.md || die

	distutils-r1_src_prepare
}
