# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit python-single-r1

DESCRIPTION="Script to migrate from split-usr to merged-usr"
HOMEPAGE="https://github.com/floppym/merge-usr"
SRC_URI="https://github.com/floppym/merge-usr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sparc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
BDEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}"

src_install() {
	python_doscript merge-usr
}
