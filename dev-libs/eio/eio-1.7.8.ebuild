# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/eio/eio-1.7.8.ebuild,v 1.1 2013/08/28 03:10:27 vapier Exp $

EAPI="4"

inherit enlightenment

DESCRIPTION="Enlightenment's integration to IO"
HOMEPAGE="http://trac.enlightenment.org/e/wiki/EIO"
SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples static-libs"

RDEPEND=">=dev-libs/ecore-1.7.8
	>=dev-libs/eet-1.7.8"
DEPEND="${RDEPEND}"

src_configure() {
	E_ECONF+=(
		--enable-posix-threads
		$(use_enable doc)
		$(use_enable examples build-examples)
		$(use_enable examples install-examples)
	)
	enlightenment_src_configure
}
