# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils apache-module

DESCRIPTION="mod_caucho connects Resin and Apache2"
HOMEPAGE="http://www.caucho.com/"
SRC_URI="http://www.caucho.com/download/resin-${PV}-src.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

need_apache2_4

APACHE2_MOD_CONF="88_${PN}"
APACHE2_MOD_DEFINE="CAUCHO"

S="${WORKDIR}/resin-${PV}"

# Although building this manually with apxs is bad, trying to make the
# build scripts behave is worse. You have to:
#
# * Patch configure.ac and Makefile.in to respect flags.
# * Run eautoreconf (or patch configure and chmod it too).
# * Inherit java-pkg-2, DEPEND on virtual/jdk, and define pkg_setup just
#   to needlessly satisfy configure or patch out large chunks of it.
# * Define src_compile to only build the Apache module.
# * It will still report an implicit declaration of cse_free. If you try
#   to fix this, it will complain that the argument count doesn't match.

APXS2_S="${S}/modules/c/src/apache2"
APXS2_ARGS="-c -DAPACHE_24 -I../common ${PN}.c ../common/stream.c ../common/config.c ../common/memory.c"

src_configure() {
	:
}
