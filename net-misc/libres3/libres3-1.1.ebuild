# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit oasis findlib

DESCRIPTION="Skylable LibreS3 - Amazon S3 open source replacement"
HOMEPAGE="http://www.skylable.com/products/libres3"
SRC_URI="http://cdn.skylable.com/source/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 openssl"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-lang/ocaml-4
	dev-ml/camlp4
	dev-ml/jsonm
	dev-ml/lwt[react,ssl]
	dev-ml/ocaml-base64
	dev-ml/ocaml-dns[lwt(-)]
	dev-ml/ocaml-ipaddr
	dev-ml/ocaml-re
	dev-ml/ocaml-ssl
	>=dev-ml/ocamlnet-3.7.4
	<dev-ml/ocamlnet-4.0.2
	dev-ml/ocamlnet[cryptokit,pcre]
	dev-ml/optcomp
	dev-ml/pcre-ocaml
	dev-ml/ounit
	dev-ml/tyxml
	dev-ml/uutf
	dev-ml/xmlm
	www-servers/ocsigenserver[sqlite]
"
DEPEND="
	sys-devel/make
	sys-devel/m4
	virtual/pkgconfig
	${RDEPEND}
"

S="${S}/libres3"

pkg_postinst() {
	einfo "*******************************************************************************"
	einfo "Just as a heads-up: LibreS3 requires a working SX cluster (net-misc/sx) to be"
	einfo "of any use. Since LibreS3 is capable of connecting to a remote SX cluster it"
	einfo "doesn't depend on it. Hence you will likely want to install it."
	einfo ""
	einfo "Standard S3 client libraries and tools (for example s3cmd, python-boto,"
	einfo "ocaml-aws, etc.) can be used to access it."
	einfo "Enjoy."
	einfo "*******************************************************************************"
}
