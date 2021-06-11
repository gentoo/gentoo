# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="sqlite"

inherit python-r1

DESCRIPTION="A CLI tool that allows direct execution of SQL-like queries on text"
HOMEPAGE="http://harelba.github.io/q/"
MY_P="q-${PV}"
SRC_URI="https://github.com/harelba/q/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Upstream is wrong
# http://harelba.github.io/q/#requirements
RDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
	')"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	: # Do not use the Makefile
}

q_install() {
	python_newexe bin/q.py q-text-as-data
}

src_install() {
	python_foreach_impl q_install
	newdoc bin/.qrc dot-qrc
	dodoc doc/*
}

pkg_postinst() {
	einfo "On Gentoo, the 'q' binary is most often provided by app-portage/portage-utils;"
	einfo "Thus, this tool is install as 'q-text-as-data' rather than 'q'."
}
