# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE="xml"

inherit eutils distutils-r1 prefix

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
HOMEPAGE="https://www.gentoo.org/proj/en/portage/tools/index.xml"
SRC_URI="https://dev.gentoo.org/~dolsen/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux"

RDEPEND="
	dev-util/dialog
	net-analyzer/netselect
	"

python_prepare_all()  {
	python_export_best
	eprefixify setup.py mirrorselect/main.py
	echo Now setting version... VERSION="${PVR}" "${PYTHON}" setup.py set_version
	VERSION="${PVR}" "${PYTHON}" setup.py set_version || die "setup.py set_version failed"
	distutils-r1_python_prepare_all
}
