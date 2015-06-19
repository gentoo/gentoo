# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/eio/eio-1.7.10.ebuild,v 1.1 2015/03/17 00:46:00 vapier Exp $

EAPI="5"

if [[ ${PV} == "9999" ]] ; then
	EGIT_SUB_PROJECT="legacy"
	EGIT_URI_APPEND=${PN}
	EGIT_BRANCH=${PN}-1.7
else
	SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="Enlightenment's integration to IO"
HOMEPAGE="http://trac.enlightenment.org/e/wiki/EIO"

LICENSE="LGPL-2"
IUSE="examples static-libs"

RDEPEND=">=dev-libs/ecore-${PV}
	>=dev-libs/eet-${PV}"
DEPEND="${RDEPEND}"

src_configure() {
	E_ECONF=(
		--enable-posix-threads
		$(use_enable doc)
		$(use_enable examples build-examples)
		$(use_enable examples install-examples)
	)
	enlightenment_src_configure
}
