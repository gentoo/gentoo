# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/libcangjie/libcangjie-1.3.ebuild,v 1.1 2015/02/28 07:49:58 dlan Exp $

EAPI=5

DESCRIPTION="The library implementing the Cangjie input method"
HOMEPAGE="http://cangjians.github.io"
SRC_URI="https://github.com/Cangjians/libcangjie/releases/download/v${PV}/libcangjie-${PV}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-db/sqlite:3="

RDEPEND="${DEPEND}"
