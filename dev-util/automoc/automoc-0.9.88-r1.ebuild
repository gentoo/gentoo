# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/automoc/automoc-0.9.88-r1.ebuild,v 1.12 2015/05/27 12:38:05 zlogene Exp $

EAPI=5

MY_PN="automoc4"
MY_P="${MY_PN}-${PV}"
inherit cmake-utils flag-o-matic

DESCRIPTION="KDE Meta Object Compiler"
HOMEPAGE="http://www.kde.org"
SRC_URI="mirror://kde/stable/${MY_PN}/${PV}/${MY_P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND="
	dev-qt/qtcore:4
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${PN}-0.9.88-objc++.patch" )

src_prepare() {
	cmake-utils_src_prepare

	if [[ ${ELIBC} = uclibc ]]; then
		append-flags -pthread
	fi
}
