# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="engine_pkcs11 is an implementation of an engine for OpenSSL"
HOMEPAGE="http://www.opensc-project.org/engine_pkcs11"
SRC_URI="https://github.com/OpenSC/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="libressl"

RDEPEND=">=dev-libs/libp11-0.3.1
	!libressl? ( >=dev-libs/openssl-0.9.7d:0 )
	libressl? ( dev-libs/libressl )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	default
	prune_libtool_files --all
}
