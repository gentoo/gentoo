# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/injeqt/injeqt-1.0.0.ebuild,v 1.1 2015/07/05 20:06:58 reavertm Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Dependency injection framework for Qt5"
HOMEPAGE="https://github.com/vogel/injeqt"
SRC_URI="https://github.com/vogel/injeqt/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-qt/qtcore-5.4.2:5
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qttest-5.4.2:5 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_disable test TESTS)
	)
	cmake-utils_src_configure
}
