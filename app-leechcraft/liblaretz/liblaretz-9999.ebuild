# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/liblaretz/liblaretz-9999.ebuild,v 1.1 2013/07/20 20:18:03 maksbotan Exp $

EAPI=5

DESCRIPTION="Shared library to be used by the Laretz sync server and its clients"
HOMEPAGE="http://leechcraft.org"

EGIT_REPO_URI="git://github.com/0xd34df00d/laretz.git"
EGIT_PROJECT="laretz"

inherit cmake-utils git-2

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}"/src/lib
