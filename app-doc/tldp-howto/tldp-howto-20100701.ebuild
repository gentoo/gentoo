# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/tldp-howto/tldp-howto-20100701.ebuild,v 1.4 2013/09/05 05:53:42 vapier Exp $

EAPI="2"

inherit confutils

DESCRIPTION="The Linux Documentation Project HOWTOs"
HOMEPAGE="http://www.tldp.org"

# Yay, unversioned distfiles
# http://www.ibiblio.org/pub/Linux/docs/HOWTO/Linux-HOWTOs.tar.bz2
# http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/html/Linux-html-HOWTOs.tar.bz2
#  ^^^ this also contains the pdfs, not sure if it's intentional as older versions don't
# http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/html_single/Linux-html-single-HOWTOs.tar.bz2
# http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/pdf/Linux-pdf-HOWTOs.tar.bz2

SRC_URI="
	html? ( mirror://gentoo/Linux-html-HOWTOs-${PV}.tar.bz2 )
	htmlsingle? ( mirror://gentoo/Linux-html-single-HOWTOs-${PV}.tar.bz2 )
	pdf? ( mirror://gentoo/Linux-pdf-HOWTOs-${PV}.tar.bz2 )
	text? ( mirror://gentoo/Linux-HOWTOs-${PV}.tar.bz2 )"

LICENSE="FDL-1.2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="+html htmlsingle pdf text"
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	confutils_require_any html htmlsingle pdf text
}

src_unpack() {
	mkdir -p "${S}"
	cd "${S}"
	if use text; then
		mkdir "${S}"/text
		pushd "${S}"/text > /dev/null
		unpack Linux-HOWTOs-${PV}.tar.bz2
		popd > /dev/null
	fi
	if use html; then
		unpack Linux-html-HOWTOs-${PV}.tar.bz2
		[[ -d ${S}/HOWTO/pdf ]] && rm -r "${S}"/HOWTO/pdf
		mv "${S}"/HOWTO "${S}"/html
	fi
	if use htmlsingle; then
		mkdir "${S}"/htmlsingle
		pushd "${S}"/htmlsingle > /dev/null
		unpack Linux-html-single-HOWTOs-${PV}.tar.bz2
		popd > /dev/null
	fi
	if use pdf; then
		mkdir "${S}"/pdf
		pushd "${S}"/pdf > /dev/null
		unpack Linux-pdf-HOWTOs-${PV}.tar.bz2
		popd > /dev/null
	fi
}

src_install() {
	if use text; then
		docinto text
		dodoc "${S}"/text/*
		rm -r "${S}"/text
	fi
	insinto /usr/share/doc/${PF}
	doins -r "${S}"/*
}
