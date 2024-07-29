# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A tool for checking the security hardening options of the Linux kernel"
HOMEPAGE="https://github.com/a13xp0p0v/kernel-hardening-checker"
LICENSE="GPL-3"
SLOT="0"

SRC_URI="https://github.com/a13xp0p0v/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
KEYWORDS="~amd64"

distutils_enable_tests pytest
