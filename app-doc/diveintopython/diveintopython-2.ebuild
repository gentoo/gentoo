# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

MY_PV="5.4"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="'Dive Into Python' by Mark Pilgrim - Python 2"
HOMEPAGE="http://www.diveintopython.net/"

SRC_URI="http://www.diveintopython.net/download/${PN}-html-${MY_PV}.zip -> ${P}.zip
	pdf? (
		http://www.diveintopython.net/download/${PN}-pdf-${MY_PV}.zip -> ${P}-pdf.zip
	)"

LICENSE="FDL-1.1"
SLOT="2"

KEYWORDS="amd64 ppc64 ppc x86"

IUSE="pdf"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
}

src_install() {
	insinto "/usr/share/doc/${PN}-${SLOT}"
	use pdf && dodoc "${PN}.pdf"
	doins -r html/*
	insinto "/usr/share/doc/${PN}-${SLOT}"/examples
	doins -r py
}
