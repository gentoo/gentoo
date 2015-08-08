# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Author a DVD-Audio DVD"
HOMEPAGE="http://dvd-audio.sourceforge.net"
SRC_URI="mirror://sourceforge/dvd-audio/${P}-300.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=media-sound/sox-14.1[png]
	>=media-libs/flac-1.2.1[ogg]"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2"

src_prepare() {
	# Fix parallel make
	sed -i -e 's:^\(\tcd ${MAYBE_CDRTOOLS}\):@HAVE_CDRTOOLS_BUILD_TRUE@\1:' \
		Makefile.in || die "sed failed"

	# Don't pre-strip binaries
	sed -i -e 's:$LIBS -s:$LIBS:' configure || die "sed failed"

	# Fix up --as-needed.
	MY_AS_NEEDED_F='$(LINK) \($(dvda_OBJECTS)\)'
	MY_AS_NEEDED_R='$(CCLD) $(AM_CFLAGS) $(CFLAGS) \1 $(AM_LDFLAGS) $(LDFLAGS) -o $@'
	sed -i -e "s/${MY_AS_NEEDED_F}/${MY_AS_NEEDED_R}/" src/Makefile.in || die "sed failed"
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--with-config=/etc \
		$(use_with debug debug full)
}

src_compile() {
	# make[1]: warning: jobserver unavailable: using -j1.
	#                   Add '+' to parent make rule.
	emake -j1
}

src_install() {
	newbin src/dvda ${PN}
	insinto /etc
	doins ${PN}.conf
	dodoc AUTHORS BUGS ChangeLog EXAMPLES HOWTO.conf LIMITATIONS NEWS TODO
}
