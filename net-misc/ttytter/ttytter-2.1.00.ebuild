# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit readme.gentoo-r1

DESCRIPTION="A multi-functional, console-based Twitter client"
HOMEPAGE="http://www.floodgap.com/software/ttytter/"
SRC_URI="http://www.floodgap.com/software/ttytter/dist2/${PV}.txt -> ${P}.txt"

LICENSE="FFSL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/perl-5.8
	|| ( net-misc/curl www-client/lynx )"

S=${WORKDIR}

src_install() {
	newbin "${DISTDIR}/${A}" ${PN}

	local DOC_CONTENTS="
		Please consult the following webpage on how to
		configure your client.
		http://www.floodgap.com/software/ttytter/dl.html"
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
