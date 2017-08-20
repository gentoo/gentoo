# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-r1 vcs-snapshot

COMMIT="29a0bbf43bfecb6872cdca0e4a11733954d25196"
DESCRIPTION="Source Code Documentation Coverage Measurement"
HOMEPAGE="https://github.com/alobbs/doxy-coverage"
SRC_URI="${HOMEPAGE}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}"

src_install() {
	default
	python_foreach_impl python_newexe "${PN}"{.py,}
}
