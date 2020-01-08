# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Provides C++ support for the HOCON configuration file format"
HOMEPAGE="https://github.com/puppetlabs/cpp-hocon"
SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/puppetlabs/cpp-hocon/commit/caab275509826dc5fe5ab2632582abb8f83ea2b3.patch -> ${PN}-0.2.1-boost-filesystem.patch"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="debug"

DEPEND="
	>=dev-libs/boost-1.54:=[nls]
	>=dev-libs/leatherman-0.9.3:=
	"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.2.1-cmake.patch )
