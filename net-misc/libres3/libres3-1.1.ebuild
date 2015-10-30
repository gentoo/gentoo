# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_TESTS=1
inherit oasis findlib

DESCRIPTION="Skylable LibreS3 - Amazon S3 open source replacement"
HOMEPAGE="http://www.skylable.com/products/libres3"
SRC_URI="http://cdn.skylable.com/source/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
OASIS_DOC_DIR="/usr/share/doc/${PF}"

RDEPEND="
	>=dev-lang/ocaml-4:=
	dev-ml/camlp4:=
	dev-ml/jsonm:=
	dev-ml/lwt:=[react,ssl]
	dev-ml/ocaml-base64:=
	dev-ml/ocaml-dns:=[lwt(-)]
	dev-ml/ocaml-ipaddr:=
	dev-ml/ocaml-re:=
	dev-ml/ocaml-ssl:=
	>=dev-ml/ocamlnet-3.7.4:=[pcre]
	<dev-ml/ocamlnet-4:=[pcre]
	dev-ml/optcomp:=
	dev-ml/ounit:=
	dev-ml/pcre-ocaml:=
	dev-ml/tyxml:=
	dev-ml/uutf:=
	dev-ml/xmlm:=
	www-servers/ocsigenserver:=[sqlite]
"
DEPEND="
	dev-ml/oasis
	virtual/pkgconfig
	${RDEPEND}
"

S="${WORKDIR}/${P}/libres3"

src_prepare() {
	sed -e '/..\/..\/COPYING/d' -i _oasis || die
	rm setup.ml || die
	emake update
}

src_configure() {
	oasis_configure_opts="
		--sysconfdir ${EPREFIX}/etc/${PN}
		--localstatedir ${EPREFIX}/var" oasis_src_configure
}

src_install() {
	emake DESTDIR="${D}" install

	if [[ -d /etc/logrotate.d ]]; then
		insinto /etc/logrotate.d
		doins src/files/conf/logrotate.d/libres3
	fi
}

pkg_postinst() {
	elog "*******************************************************************************"
	elog "Just as a heads-up: LibreS3 requires a working SX cluster (net-misc/sx) to be"
	elog "of any use. Since LibreS3 is capable of connecting to a remote SX cluster it"
	elog "doesn't depend on it. Hence you will likely want to install it."
	elog ""
	elog "Standard S3 client libraries and tools (for example s3cmd, python-boto,"
	elog "ocaml-aws, etc.) can be used to access it."
	elog "Enjoy."
	elog "*******************************************************************************"
}
