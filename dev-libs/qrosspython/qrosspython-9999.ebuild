# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/qrosspython/qrosspython-9999.ebuild,v 1.5 2014/08/10 20:39:18 slyfox Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
EGIT_REPO_URI="git://github.com/0xd34df00d/Qross.git"

inherit git-r3 python-single-r1 cmake-utils

DESCRIPTION="Python scripting backend for Qross"
HOMEPAGE="http://github.com/0xd34df00d/Qross"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="
	~dev-libs/qrosscore-${PV}
	dev-python/sip
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	dev-qt/qttest:4
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CMAKE_USE_DIR="${S}/src/bindings/python/qrosspython"
