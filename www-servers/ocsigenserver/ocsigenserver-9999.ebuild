# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib findlib user

if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/ocsigen/ocsigenserver"
	KEYWORDS=""
else
	SRC_URI="https://github.com/ocsigen/ocsigenserver/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Ocaml-powered webserver and framework for dynamic web programming"
HOMEPAGE="http://www.ocsigen.org"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
IUSE="debug doc dbm +ocamlopt +sqlite zlib"
REQUIRED_USE="|| ( sqlite dbm )"
RESTRICT="strip installsources"

DEPEND=">=dev-ml/lwt-2.5.0:=[react,ssl]
		>=dev-ml/react-0.9.3:=
		zlib? ( >=dev-ml/camlzip-1.03-r1:= )
		dev-ml/cryptokit:=
		>=dev-ml/ocamlnet-3.6:=[pcre]
		>=dev-ml/pcre-ocaml-6.2.5:=
		>=dev-ml/tyxml-4:=[camlp4(+)]
		>=dev-lang/ocaml-3.12:=[ocamlopt?]
		dev-ml/ocaml-ipaddr:=
		dbm? ( dev-ml/camldbm:= )
		sqlite? ( dev-ml/ocaml-sqlite3:= )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup ocsigenserver
	enewuser ocsigenserver -1 -1 /var/www ocsigenserver
}

src_configure() {
	sh configure \
		--prefix /usr \
		--temproot "${ED}" \
		--bindir /usr/bin \
		--docdir /usr/share/doc/${PF} \
		--mandir /usr/share/man/man1 \
		--libdir /usr/$(get_libdir)/ocaml \
		$(use_enable debug) \
		$(use_with zlib camlzip) \
		$(use_with sqlite) \
		$(use_with dbm) \
		--with-preempt \
		--ocsigen-group ocsigenserver \
		--ocsigen-user ocsigenserver  \
		--name ocsigenserver \
		|| die "Error : configure failed!"
}

src_compile() {
	if use ocamlopt; then
		emake
	else
		emake byte
	fi
	use doc && emake doc
}

src_install() {
	findlib_src_preinst
	if use ocamlopt; then
		emake install
	else
		emake install.byte
	fi
	if use doc ; then
		emake install.doc
	fi
	emake logrotate

	newinitd "${FILESDIR}"/ocsigenserver.initd ocsigenserver || die
	newconfd "${FILESDIR}"/ocsigenserver.confd ocsigenserver || die

	dodoc README.md

	# We create it at runtime
	rm -f "${ED}/var/run/ocsigenserver_command" || die
}
