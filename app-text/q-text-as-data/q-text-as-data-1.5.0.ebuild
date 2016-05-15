# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
# Does not yet support py3
PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="q: Text as Data is a CLI tool that allows direct execution of SQL-like queries on text"
HOMEPAGE="http://harelba.github.io/q/"
MY_P="q-${PV}"
SRC_URI="https://github.com/harelba/q/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# No dependencies other than python >= 2.5
# http://harelba.github.io/q/requirements.html
RDEPEND="${PYTHON_DEPS}"
DEPEND=""

S="${WORKDIR}/${MY_P}"

q_install() {
	python_newexe bin/q q-text-as-data
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
