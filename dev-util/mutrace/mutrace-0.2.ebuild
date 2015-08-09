# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A mutex tracer/profiler"
HOMEPAGE="http://0pointer.de/blog/projects/mutrace.html"
SRC_URI="http://0pointer.de/public/${P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
IUSE=""

DEPEND="sys-devel/binutils:*"
RDEPEND="${DEPEND}"

src_prepare() {
	# Fails to build due to missing header, bug #430706
	epatch "${FILESDIR}"/${PN}-0.2-missing-header.patch
}
