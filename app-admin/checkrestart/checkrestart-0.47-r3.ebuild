# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/checkrestart/checkrestart-0.47-r3.ebuild,v 1.1 2014/12/14 23:01:28 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="the sysadmin's rolling upgrade tool"
HOMEPAGE="http://arcdraco.net/checkrestart"
SRC_URI="http://arcdraco.net/~dragon/${P}-sep.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	sys-apps/lsb-release
	app-portage/portage-utils
	sys-process/lsof
"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-list-comprehension-fix.patch
	python_fix_shebang ${PN}
}

src_install() {
	dosbin ${PN}
}
