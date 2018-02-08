# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Linux Kernel in a Nutshell: A Desktop Quick Reference"
HOMEPAGE="http://www.kroah.com/lkn/"
SRC_URI="mirror://kernel/linux/kernel/people/gregkh/lkn/lkn_pdf.tar.bz2
	mirror://kernel/linux/kernel/people/gregkh/lkn/lkn_xml.tar.bz2"

LICENSE="CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/doc/${PN}/pdf
	doins -r lkn_pdf/*
	insinto /usr/share/doc/${PN}/xml
	doins -r lkn_xml/*
}
