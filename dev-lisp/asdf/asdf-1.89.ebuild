# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/asdf/asdf-1.89.ebuild,v 1.4 2012/10/10 10:30:20 blueness Exp $

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
KEYWORDS="alpha amd64 ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

EPATCH_SOURCE="${WORKDIR}"
S="${WORKDIR}"/${MY_P}.orig

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
