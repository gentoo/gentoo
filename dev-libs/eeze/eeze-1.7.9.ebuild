# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit enlightenment

DESCRIPTION="library to simplify the use of devices"
HOMEPAGE="http://trac.enlightenment.org/e/wiki/Eeze"
SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs utilities"

DEPEND=">=dev-libs/ecore-1.7.9
	>=dev-libs/eina-1.7.9
	>=dev-libs/eet-1.7.9
	virtual/udev"
RDEPEND="${DEPEND}"

src_configure() {
	E_ECONF+=(
		$(use_enable doc)
		$(use_enable utilities eeze-disk-ls)
		$(use_enable utilities eeze-mount)
		$(use_enable utilities eeze-umount)
		$(use_enable utilities eeze-udev-test)
	)
	enlightenment_src_configure
}
