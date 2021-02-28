# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

MY_P=${P/_beta/test}
DESCRIPTION="Modules for OCaml application-level Internet protocols"
HOMEPAGE="http://projects.camlcity.org/projects/ocamlnet.html"
SRC_URI="http://download.camlcity.org/download/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB GPL-2+"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="kerberos tk httpd +ocamlopt +pcre ssl zip"
RESTRICT="installsources strip"

# the auth-dh compile flag has been disabled as well, since it depends on
# ocaml-cryptgps, which is not available.

BDEPEND="
	dev-ml/cppo
	virtual/pkgconfig
"
RDEPEND="
	>=dev-ml/findlib-1.0
	>=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	pcre? ( >=dev-ml/pcre-ocaml-5:= )
	tk? ( dev-ml/labltk:= )
	ssl? ( net-libs/gnutls:= )
	kerberos? ( virtual/krb5 )
	zip? ( dev-ml/camlzip:= )
"
DEPEND="${RDEPEND}"

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
		$(ocamlnet_use_enable kerberos gssapi) \
		$(ocamlnet_use_enable pcre pcre) \
		$(ocamlnet_use_enable tk tcl) \
		$(ocamlnet_use_enable zip zip) \
		$(ocamlnet_use_with httpd nethttpd) \
		|| die "Error: econf failed!"
}

src_compile() {
	emake -j1 all
	if use ocamlopt; then
		emake -j1 opt
	fi
}

src_install() {
	findlib_src_install
}
