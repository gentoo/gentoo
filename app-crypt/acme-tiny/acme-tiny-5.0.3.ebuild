# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Tiny, auditable script for Let's Encrypt's ACME Protocol"
HOMEPAGE="https://github.com/diafygi/acme-tiny"
SRC_URI="https://github.com/diafygi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"
RDEPEND="dev-libs/openssl:0"

# Tests require a local ACME server to be set up.
RESTRICT="test"

export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"

src_prepare() {
	sed -i 's|#!/usr/bin/sh|#!/bin/sh|g' README.md || die

	distutils-r1_src_prepare
}
