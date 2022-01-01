# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib flag-o-matic toolchain-funcs

DESCRIPTION="A set of tools to transform, query, validate, and edit XML documents"
HOMEPAGE="http://xmlstar.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmlstar/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/libgcrypt:0=
	virtual/libiconv"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# We need to patch use of /usr/lib because it is a problem with
	# linker lld with profile 17.1 on amd64 (see https://bugs.gentoo.org/729600).
	# The grep sandwich acts as a regression test so that a future
	# version bump cannot break patching without noticing.
	grep -wq _PREFIX/lib m4/xstar-check-libs.m4 || die
	sed "s,_PREFIX/lib,_PREFIX/$(get_libdir)," -i m4/xstar-check-libs.m4 || die
	grep -w _PREFIX/lib m4/xstar-check-libs.m4 && die

	eautoreconf
}

src_configure() {
	append-cppflags $($(tc-getPKG_CONFIG) --cflags libxml-2.0)

	# NOTE: Fully built documentation is already shipped with the tarball:
	# - doc/xmlstarlet-ug.{pdf,ps,html}
	# - doc/xmlstarlet.txt
	# - doc/xmlstarlet.1
	econf \
		--disable-build-docs \
		--disable-static-libs
}

src_install() {
	default
	dosym xml /usr/bin/xmlstarlet
}
