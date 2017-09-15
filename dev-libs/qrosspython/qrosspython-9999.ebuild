# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit git-r3 python-single-r1 cmake-utils

EGIT_REPO_URI="https://github.com/0xd34df00d/Qross.git"

DESCRIPTION="Python scripting backend for Qross"
HOMEPAGE="https://github.com/0xd34df00d/Qross"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="
	~dev-libs/qrosscore-${PV}
	dev-python/sip
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	dev-qt/qttest:5
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CMAKE_USE_DIR="${S}/src/bindings/python/qrosspython"

mycmakeargs=( -DUSE_QT5=ON )
