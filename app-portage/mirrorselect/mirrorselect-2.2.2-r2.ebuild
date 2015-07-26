# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/mirrorselect/mirrorselect-2.2.2-r2.ebuild,v 1.2 2015/07/18 13:49:55 zlogene Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="xml"

inherit eutils distutils-r1 prefix

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Mirrorselect"
SRC_URI="http://dev.gentoo.org/~dolsen/releases/mirrorselect/${P}.tar.gz
	http://dev.gentoo.org/~dolsen/releases/mirrorselect/mirrorselect-test
	"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"

RDEPEND="
	dev-util/dialog
	net-analyzer/netselect
	>=dev-python/ssl-fetch-0.3[${PYTHON_USEDEP}]
	"

PATCHES=(
	"${FILESDIR}/mirrorselect-2.2.2-Update-for-ssl-fetch-api-change.patch"
	"${FILESDIR}/mirrorselect-2.2.2-Add-outputmodefunctionassignment.patch"
)

python_prepare_all()  {
	python_setup
	eprefixify setup.py mirrorselect/main.py
	echo Now setting version... VERSION="${PVR}" "${PYTHON}" setup.py set_version
	VERSION="${PVR}" "${PYTHON}" setup.py set_version || die "setup.py set_version failed"
	distutils-r1_python_prepare_all
}
