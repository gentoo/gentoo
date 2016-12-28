# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A LuaDoc-compatible documentation generation system"
HOMEPAGE="http://stevedonovan.github.com/ldoc/"
SRC_URI="https://github.com/stevedonovan/LDoc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="dev-lua/penlight"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.6-mkdir.patch"
)

S="${WORKDIR}/LDoc-${PV}"
RESTRICT="!test? ( test )"
