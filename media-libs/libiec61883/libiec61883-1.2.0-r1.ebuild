# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-multilib eutils unpacker autotools

DESCRIPTION="Library for capturing video (dv or mpeg2) over the IEEE 1394 bus"
HOMEPAGE="http://dennedy.org/cgi-bin/gitweb.cgi?p=dennedy.org/libiec61883.git"
SRC_URI="https://www.kernel.org/pub/linux/libs/ieee1394/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ia64 ppc ppc64 sparc x86"
IUSE="examples static-libs"

RDEPEND=">=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	if use examples; then
		sed -i -e "s:noinst_PROGRAMS.*:noinst_PROGRAMS = :g" \
		-e "s:in_PROGRAMS.*:in_PROGRAMS = plugreport plugctl test-amdtp test-dv	test-mpeg2 test-plugs:g" \
		examples/Makefile.am || die "noinst patching failed"
		AUTOTOOLS_AUTORECONF="1"
	fi
	autotools-multilib_src_prepare
}
