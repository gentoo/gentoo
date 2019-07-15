# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="A mutex tracer/profiler"
HOMEPAGE="http://0pointer.de/blog/projects/mutrace.html"
SRC_URI="http://0pointer.de/public/${P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="sys-libs/binutils-libs:="
RDEPEND="${DEPEND}"

src_prepare() {
	# Fails to build due to missing header, bug #430706
	epatch "${FILESDIR}"/${PN}-0.2-missing-header.patch
}
