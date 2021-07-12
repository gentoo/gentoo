# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit python-r1

DESCRIPTION="MarkupPy - An HTML/XML generator"
HOMEPAGE="https://github.com/scardracs/MarkupPy"
SRC_URI="https://github.com/scardracs/MarkupPy/releases/download/${PV}/MarkupPy-${PV}.tar.gz"
S="${WORKDIR}"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64"

# MarkupPy does not have any test suite
RESTRICT="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="${PYTHON_DEPS}"
