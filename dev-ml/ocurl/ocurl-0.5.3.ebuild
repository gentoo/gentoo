# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocurl/ocurl-0.5.3.ebuild,v 1.5 2013/07/10 13:53:34 vincent Exp $

EAPI=5

inherit eutils findlib autotools

DESCRIPTION="OCaml interface to the libcurl library"
HOMEPAGE="http://sourceforge.net/projects/ocurl"
LICENSE="MIT"
SRC_URI="mirror://sourceforge/ocurl/${P}.tgz"

SLOT="0/${PV}"
IUSE="examples"

DEPEND=">=net-misc/curl-7.9.8
		dev-libs/openssl
		>=dev-lang/ocaml-3.12:=[ocamlopt]"
RDEPEND="${DEPEND}"
KEYWORDS="amd64 ppc x86"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.5.1-asneeded.patch"
	eautoreconf
}

src_configure() {
	econf --with-findlib
}

src_compile()
{
	emake -j1 all || die
}

src_install()
{
	findlib_src_install
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
