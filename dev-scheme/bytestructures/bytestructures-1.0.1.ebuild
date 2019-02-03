# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Structured access to bytevector contents"
HOMEPAGE="https://github.com/TaylanUB/scheme-bytestructures/"
SRC_URI="https://github.com/TaylanUB/scheme-bytestructures/releases/download/v${PV}/bytestructures-${PV}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-scheme/guile-2.0.0:="
DEPEND="${RDEPEND}"
