# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="AnteChamber PYthon Parser interfacE"
HOMEPAGE="https://github.com/llazzaro"
SRC_URI="https://github.com/llazzaro/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	sci-chemistry/openbabel
	sci-chemistry/ambertools"
RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e '1s:^:#!/usr/bin/python\n\n:g' \
		-i acpype/CcpnToAcpype.py || die
	default
}
