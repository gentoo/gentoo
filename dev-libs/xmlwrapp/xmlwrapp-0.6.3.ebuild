# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="modern style C++ library that provides a simple and easy interface to libxml2"
HOMEPAGE="http://sourceforge.net/projects/xmlwrapp/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="static-libs"

RDEPEND="dev-libs/boost:=
	dev-libs/libxml2
	dev-libs/libxslt"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	epatch_user

	# buildsystem forgot about this
	append-libs -lboost_system
}

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
