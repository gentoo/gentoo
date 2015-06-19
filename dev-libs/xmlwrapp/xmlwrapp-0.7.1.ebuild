# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xmlwrapp/xmlwrapp-0.7.1.ebuild,v 1.10 2014/03/19 13:51:57 ago Exp $

EAPI=5

inherit eutils

DESCRIPTION="modern style C++ library that provides a simple and easy interface to libxml2"
HOMEPAGE="http://vslavik.github.io/xmlwrapp/"
SRC_URI="https://github.com/vslavik/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="static-libs"

RDEPEND="dev-libs/boost:=
	dev-libs/libxml2
	dev-libs/libxslt"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	epatch_user
}

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--htmldir="/usr/share/doc/${PF}/html" \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
