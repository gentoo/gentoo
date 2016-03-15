# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Shotgun assembly and alignment utilities"
HOMEPAGE="http://www.phrap.org/"
SRC_URI="phrap-${PV}-distrib.tar.gz"

LICENSE="phrap"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-lang/perl
	dev-perl/Tk"

S="${WORKDIR}"

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please visit http://www.phrap.org/phredphrapconsed.html and obtain the file"
	einfo "\"distrib.tar.gz\", then rename it to \"phrap-${PV}-distrib.tar.gz\""
	einfo "and put it in ${DISTDIR}"
}

src_prepare() {
	sed -i 's/CFLAGS=/#CFLAGS=/' makefile || die
	sed -i 's|#!/usr/local/bin/perl|#!/usr/bin/env perl|' phrapview || die
}

src_install() {
	dobin cross_match loco phrap phrapview swat
	newbin cluster cluster_phrap
	for i in {general,phrap,swat}.doc ; do
		newdoc ${i} ${i}.txt
	done
}
