# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Adds multiple ssh keys to the ssh authentication agent"
HOMEPAGE="http://code.fluffytapeworm.com/projects"
SRC_URI="http://code.fluffytapeworm.com/projects/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="
	${PYTHON_DEPS}
	X? ( >=net-misc/x11-ssh-askpass-1.2.2 )"

src_prepare() {
	python_fix_shebang .
}

src_compile() {
	:
}

src_install() {
	dobin ssh-multiadd
	doman ssh-multiadd.1
	dodoc Changelog README todo
}
