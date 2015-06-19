# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/htmlc/htmlc-2.40.0.ebuild,v 1.2 2013/12/24 12:55:56 ago Exp $

EAPI=5

# Override version: 2.4.0 > 2.21.0 so we name it 2.40.0
MY_P="${P/0[.]/.}"

DESCRIPTION="HTML template files expander"
HOMEPAGE="http://htmlc.inria.fr/"
SRC_URI="http://htmlc.inria.fr/${MY_P}.tgz"

LICENSE="htmlc"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="+ocamlopt"
# Files for the tests are missing...
#RESTRICT="test"

DEPEND=">=dev-lang/ocaml-3.11.2:=[ocamlopt?]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	./configure \
		--install-root-dir "${ED}usr" \
		|| die
}

src_compile() {
	if use ocamlopt ; then
		emake bin
	else
		emake byt
	fi
}

src_install() {
	if use ocamlopt ; then
		emake installbin
	else
		emake installbyt
	fi
	emake MANDIR='$(PREFIXINSTALLDIR)/share/man/man$(MANEXT)' installman
	dodoc README Announce* CHANGES
}
