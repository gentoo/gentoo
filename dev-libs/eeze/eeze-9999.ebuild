# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

DESCRIPTION="library to simplify the use of devices"
HOMEPAGE="http://trac.enlightenment.org/e/wiki/Eeze"

LICENSE="BSD-2"
IUSE="static-libs utilities"

DEPEND=">=dev-libs/ecore-${PV}
	>=dev-libs/eina-${PV}
	>=dev-libs/eet-${PV}
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
