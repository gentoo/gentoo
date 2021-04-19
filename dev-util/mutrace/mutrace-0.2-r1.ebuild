# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A mutex tracer/profiler"
HOMEPAGE="http://0pointer.de/blog/projects/mutrace.html"
SRC_URI="http://0pointer.de/public/${P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="sys-libs/binutils-libs:="
RDEPEND="${DEPEND}"

PATCHES=(
	# Fails to build due to missing header, bug #430706
	"${FILESDIR}"/${PN}-0.2-missing-header.patch
)
