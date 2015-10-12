# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit enlightenment

DESCRIPTION="Enlightenment's integration to IO"
HOMEPAGE="https://trac.enlightenment.org/e/wiki/EIO"
SRC_URI="https://download.enlightenment.org/releases/${P}.tar.bz2"

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
