# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/gitinspector/gitinspector-0.3.1.ebuild,v 1.2 2015/04/08 17:53:03 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Statistical analysis tool for git repositories"
HOMEPAGE="https://code.google.com/p/gitinspector/"
SRC_URI="https://${PN}.googlecode.com/files/${PN}_${PV}.zip"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-vcs/git"
DEPEND="
	test? ( ${RDEPEND} )"
