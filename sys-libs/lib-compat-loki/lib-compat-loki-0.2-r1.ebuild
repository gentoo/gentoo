# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/lib-compat-loki/lib-compat-loki-0.2-r1.ebuild,v 1.3 2015/06/01 20:41:14 mr_bones_ Exp $

EAPI=5

DESCRIPTION="Compatibility libc6 libraries for Loki games"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://www.blfh.de/gentoo/distfiles/${P}.tar.bz2
	http://dev.gentoo.org/~wolf31o2/sources/lib-compat-loki/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/lib-compat
	>=media-libs/libsdl-1.2.15-r4[abi_x86_32(-)]"

# I'm not quite sure if this is necessary:
RESTRICT="strip"

S=${WORKDIR}/${P}/x86

src_prepare() {
	# rename the libs in order to _never_ overwrite any existing lib.
	mv libc-2.2.5.so loki_libc.so.6 || die
	mv ld-2.2.5.so loki_ld-linux.so.2 || die
	mv libnss_files-2.2.5.so loki_libnss_files.so.2 || die
	mv libsmpeg-0.4.so.0 loki_libsmpeg-0.4.so.0 || die
}

src_install() {
	ABI=x86

	into /
	dolib.so loki_ld-linux.so.2
	rm -f loki_ld-linux.so.2
	into /usr
	dolib.so *.so*
}
