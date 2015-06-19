# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/embryo/embryo-9999.ebuild,v 1.6 2015/03/17 00:49:48 vapier Exp $

EAPI="4"

if [[ ${PV} == "9999" ]] ; then
	EGIT_SUB_PROJECT="legacy"
	EGIT_URI_APPEND=${PN}
	EGIT_BRANCH=${PN}-1.7
else
	SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="load and control programs compiled in embryo language (small/pawn variant)"

LICENSE="BSD-2 ZLIB"
IUSE="static-libs"

DEPEND=">=dev-libs/eina-${PV}"
RDEPEND="${DEPEND}"
