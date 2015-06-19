# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ttytter/ttytter-2.1.00.ebuild,v 1.3 2013/09/14 10:05:09 ago Exp $

EAPI="5"

inherit readme.gentoo

DESCRIPTION="A multi-functional, console-based Twitter client"
HOMEPAGE="http://www.floodgap.com/software/ttytter/"
SRC_URI="http://www.floodgap.com/software/ttytter/dist2/${PV}.txt"

LICENSE="FFSL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND=""
RDEPEND=">=dev-lang/perl-5.8
	|| ( net-misc/curl www-client/lynx )"

pkg_setup() {
	DOC_CONTENTS="Please consult the following webpage on how to
	configure your client.
	http://www.floodgap.com/software/ttytter/dl.html"
}

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${A} ${WORKDIR}/${PN} || die
}

src_install() {
	dobin ${PN}
	readme.gentoo_create_doc
}
