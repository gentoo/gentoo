# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mini-xml/mini-xml-2.8.ebuild,v 1.5 2014/08/13 09:35:55 ago Exp $

EAPI=5

inherit autotools multilib

MY_P="${P/mini-xml/mxml}"

DESCRIPTION="Small XML parsing library to read XML and XML-like data files"
HOMEPAGE="http://www.minixml.org/"
SRC_URI="http://www.msweet.org/files/project3/${MY_P}.tar.gz"

LICENSE="Mini-XML"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="threads static-libs"

DEPEND="virtual/pkgconfig"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -e "s:755 -s:755:" \
		-e "/^TARGETS/s: testmxml::" \
		-e 's:$(DSO) $(DSOFLAGS) -o libmxml.so.1.5 $(LIBOBJS):$(DSO) $(DSOFLAGS) $(LDFLAGS) -o libmxml.so.1.5 $(LIBOBJS):' \
			-i Makefile.in || die "sed failed"
	sed -i -e 's:OPTIM="-Os -g":OPTIM="":' configure.in || die "sed failed"
	rm configure
#	eautoreconf
	eautoconf
}

src_configure() {
	econf \
		--enable-shared \
		--libdir="/usr/$(get_libdir)" \
		--with-docdir="/usr/share/doc/${PF}/html" \
		$(use_enable threads)
}

src_compile() {
	emake libmxml.so.1.5 mxmldoc doc/mxml.man
}

src_install() {
	emake DSTROOT="${D}" install

	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/libmxml.a || die
	fi

	dodoc ANNOUNCEMENT CHANGES README
	rm "${D}/usr/share/doc/${PF}/html/"{CHANGES,COPYING,README} || die
}

src_test() {
	emake testmxml
}
