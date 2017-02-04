# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 cmake-utils

DESCRIPTION="Python scripting backend for Qross"
HOMEPAGE="https://github.com/0xd34df00d/Qross"
SRC_URI="https://github.com/0xd34df00d/Qross/archive/${PV}.tar.gz -> qrosscore-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

S="${WORKDIR}/Qross-${PV}"
CMAKE_USE_DIR="${S}/src/bindings/python/qrosspython"

mycmakeargs=( -DUSE_QT5=ON )
