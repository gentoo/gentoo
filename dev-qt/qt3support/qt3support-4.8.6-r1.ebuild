# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qt3support/qt3support-4.8.6-r1.ebuild,v 1.9 2015/08/06 13:44:58 zlogene Exp $

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="The Qt3Support module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS="alpha arm hppa ia64 ppc ppc64"
else
	KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

IUSE="+accessibility"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,qt3support,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[accessibility=,aqua=,debug=,qt3support,${MULTILIB_USEDEP}]
	~dev-qt/qtsql-${PV}[aqua=,debug=,qt3support,${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/qt3support
	src/tools/uic3
	tools/porting"

multilib_src_configure() {
	local myconf=(
		-qt3support
		$(qt_use accessibility)
	)
	qt4_multilib_src_configure
}
