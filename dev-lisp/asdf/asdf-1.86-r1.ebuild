# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
DEB_PV="1"
MY_PN="cl-${PN}"
MY_P="${MY_PN}-${PV}"

inherit eutils

DESCRIPTION="ASDF is Another System Definition Facility for Common Lisp"
HOMEPAGE="http://packages.debian.org/unstable/devel/cl-asdf"
SRC_URI="mirror://gentoo/${MY_PN}_${PV}.orig.tar.gz
	mirror://gentoo/${MY_PN}_${PV}-${DEB_PV}.diff.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 s390 sparc x86"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

EPATCH_SOURCE="${WORKDIR}"
S="${WORKDIR}"/${MY_P}

src_prepare() {
	epatch ${MY_PN}_${PV}-${DEB_PV}.diff || die
}

src_install() {
	insinto /usr/share/common-lisp/source/asdf
	doins asdf.lisp wild-modules.lisp asdf-install.lisp

	dodoc README

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins test/*
	fi
}
