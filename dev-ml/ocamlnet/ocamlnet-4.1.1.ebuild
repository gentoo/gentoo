# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils findlib

MY_P=${P/_beta/test}
DESCRIPTION="Modules for OCaml application-level Internet protocols"
HOMEPAGE="http://projects.camlcity.org/projects/ocamlnet.html"
SRC_URI="http://download.camlcity.org/download/${MY_P}.tar.gz"

LICENSE="ZLIB GPL-2+"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="gtk kerberos tk httpd +ocamlopt +pcre ssl zip"
RESTRICT="installsources"

# the auth-dh compile flag has been disabled as well, since it depends on
# ocaml-cryptgps, which is not available.

RDEPEND=">=dev-ml/findlib-1.0
		pcre? ( >=dev-ml/pcre-ocaml-5:= )
		>=dev-lang/ocaml-3.10.2:=[ocamlopt?]
		tk? ( || ( dev-ml/labltk <dev-lang/ocaml-4.02[tk] ) )
		ssl? ( net-libs/gnutls:= )
		gtk? ( >=dev-ml/lablgtk-2:= )
		kerberos? ( virtual/krb5 )
		zip? ( dev-ml/camlzip:= )
		"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	has_version '>=dev-lang/ocaml-4.03' && epatch "${FILESDIR}/oc43.patch"
}

ocamlnet_use_with() {
	if use $1; then
		echo "-with-$2"
	else
		echo "-without-$2"
	fi
}

ocamlnet_use_enable() {
	if use $1; then
		echo "-enable-$2"
	else
		echo "-disable-$2"
	fi
}

src_configure() {
	./configure \
		-bindir /usr/bin \
		-datadir /usr/share/${PN} \
		$(ocamlnet_use_enable ssl gnutls) \
		$(ocamlnet_use_enable gtk gtk2) \
		$(ocamlnet_use_enable kerberos gssapi) \
		$(ocamlnet_use_enable pcre pcre) \
		$(ocamlnet_use_enable tk tcl) \
		$(ocamlnet_use_enable zip zip) \
		$(ocamlnet_use_with httpd nethttpd) \
		|| die "Error : econf failed!"
}

src_compile() {
	emake -j1 all
	if use ocamlopt; then
		emake -j1 opt
	fi
}

src_install() {
	export STRIP_MASK="*/bin/*"
	findlib_src_install
}
