# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A LuaDoc-compatible documentation generation system"
HOMEPAGE="https://stevedonovan.github.io/ldoc/"
SRC_URI="https://github.com/stevedonovan/LDoc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64"
IUSE=""

RDEPEND="dev-lua/penlight"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.4.6-mkdir.patch" )

S="${WORKDIR}/LDoc-${PV}"
RESTRICT="test"
