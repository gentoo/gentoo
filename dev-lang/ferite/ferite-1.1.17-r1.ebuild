# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools eutils multilib

DESCRIPTION="A clean, lightweight, object oriented scripting language"
HOMEPAGE="http://www.ferite.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="~alpha amd64 ppc -sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="
	>=dev-libs/libpcre-5
	dev-libs/libxml2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/ferite-pcre.patch

	# use docsdir variable, install to DESTDIR
	sed \
		-e '/docsdir =/!s:$(prefix)/share/doc/ferite:$(DESTDIR)$(docsdir):' \
		-i docs/Makefile.am || die

	# Install docs to /usr/share/doc/${PF}, not .../${PN}
	sed \
		-e "s:doc/ferite:doc/${PF}:" \
		-i Makefile.am \
		docs/Makefile.am \
		scripts/test/Makefile.am \
		scripts/test/rmi/Makefile.am || die

	# Don't override the user's LDFLAGS
	sed \
		-e 's:_LDFLAGS = :&$(AM_LDFLAGS) :' \
		-e '/^LDFLAGS/s:^:AM_:' \
		-i modules/*/Makefile.am \
		libs/{aphex,triton}/src/Makefile.am \
		src/Makefile.am || die

	# Only build/install shared libs for modules (can't use static anyway)
	sed -i -e '/_LDFLAGS/s:-module:& -shared:' modules/*/Makefile.am || die

	# use LIBADD to ensure proper deps (fix parallel build)
	sed \
		-e '/^stream_la_LDFLAGS/s:-L\. -lferitestream::' \
		-e '/^stream_la_LIBADD/s:$:libferitestream.la:' \
		-i modules/stream/Makefile.am || die

	# Make sure we install in $(get_libdir), not lib
	sed -i -e "s|\$prefix/lib|\$prefix/$(get_libdir)|g" configure.ac || die

	# We copy feritedoc to ${T} in src_install, then patch it in-situ
	# note that this doesn't actually work right, currently - it still tries
	# to pull from / instead of ${D}, and I can't figure out how to fix that
	sed -i -e 's:$(prefix)/bin/:${T}/:' docs/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf --libdir="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	cp tools/doc/feritedoc "${T}" || die
	sed -i -e '/^prefix/s:prefix:${T}:g' "${T}"/feritedoc || die
	sed -i -e '/^$prefix/s:$prefix/bin/ferite:'"${ED}"'usr/bin/ferite:' "${T}"/feritedoc || die
	sed -i -e 's:$library_path $library_path:${S}/tools/doc ${S}/tools/doc:' "${T}"/feritedoc || die
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}${LD_LIBRARY_PATH:+:}${ED}usr/lib"
	emake DESTDIR="${D}" LIBDIR="${EPREFIX}"/usr/$(get_libdir) install
	prune_libtool_files
}
