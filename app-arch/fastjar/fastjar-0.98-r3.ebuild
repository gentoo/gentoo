# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A jar program written in C"
HOMEPAGE="https://savannah.nongnu.org/projects/fastjar"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~sparc-solaris"

DEPEND="sys-libs/zlib"
RDEPEND="
	${DEPEND}
	!<=dev-java/kaffe-1.1.7-r5" # bug 188542

PATCHES=(
	# bug 325557
	"${FILESDIR}"/0.98-traversal.patch
)
