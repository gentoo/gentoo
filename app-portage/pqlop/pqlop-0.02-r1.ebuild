# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit python-r1

DESCRIPTION="emerge.log parser written in python"
HOMEPAGE="https://bitbucket.org/LK4D4/pqlop"
SRC_URI="https://bitbucket.org/LK4D4/pqlop/raw/${PV}/pqlop.py -> ${P}.py"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	newbin "${DISTDIR}"/${P}.py ${PN}
	python_replicate_script "${ED}"/usr/bin/${PN} || die "python_replicate_script failed"
}
