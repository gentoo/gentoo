# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python bindings for libdiscid"
HOMEPAGE="https://github.com/JonnyJD/python-discid"
SRC_URI="https://github.com/JonnyJD/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND=">=media-libs/libdiscid-0.2.2"
DEPEND="${RDEPEND}"

distutils_enable_sphinx doc
distutils_enable_tests setup.py
