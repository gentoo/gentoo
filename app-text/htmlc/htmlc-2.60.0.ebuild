# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/htmlc/htmlc-2.60.0.ebuild,v 1.2 2015/06/18 08:45:33 aballier Exp $

EAPI=5

inherit eutils

# Override version: 2.4.0 > 2.21.0 so we name it 2.40.0
MY_P="${P/0[.]/.}"

DESCRIPTION="HTML template files expander"
HOMEPAGE="http://htmlc.inria.fr/"
SRC_URI="http://htmlc.inria.fr/${MY_P%.0}.tgz"

LICENSE="htmlc"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+ocamlopt"
# Files for the tests are missing...
#RESTRICT="test"

DEPEND=">=dev-lang/ocaml-3.11.2:=[ocamlopt?]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/werror.patch"
}

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
