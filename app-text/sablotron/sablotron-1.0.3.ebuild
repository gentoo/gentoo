# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sablotron/sablotron-1.0.3.ebuild,v 1.15 2013/07/24 02:34:53 jer Exp $

EAPI="3"

inherit base autotools

MY_PN="Sablot"
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="An XSLT Parser in C++"
HOMEPAGE="http://www.gingerall.org/sablotron.html"
SRC_URI="http://download-1.gingerall.cz/download/sablot/${MY_P}.tar.gz"

# Sablotron can optionally be built under GPL, using MPL for now
LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="perl"

RDEPEND=">=dev-libs/expat-1.95.6-r1"
DEPEND="${RDEPEND}
	>=dev-perl/XML-Parser-2.3"

PATCHES=( "${FILESDIR}/1.0.3-libsablot-expat.patch" )

src_prepare() {
	base_src_prepare
	sed -i configure.in -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	eautoreconf
	elibtoolize
}

src_configure() {
	econf \
		$(use_enable perl perlconnect) \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	dodoc README README_JS RELEASE src/TODO
}
