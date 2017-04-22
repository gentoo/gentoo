# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# 3.x is currenlty very buggy, only 2.7 actually works
PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Google tool for managing git, particularly multiple repos"
HOMEPAGE="https://android.googlesource.com/tools/repo"
SRC_URI="https://android.googlesource.com/tools/repo/+archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	python_foreach_impl python_fix_shebang ./repo
	python_foreach_impl python_doexe ./repo
}
