# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="/usr/bin wrapper scripts for FreeBSD script compatibility"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="userland_BSD userland_GNU"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

dowrap() {
	local x
	for x do
		[[ -e ${x} ]] || die "${x} does not exist"
		newbin - "$(basename "${x}")" <<-EOF
			#!/bin/sh
			exec ${x} \${1:+"\$@"}
		EOF
	done
}

src_install() {
	dowrap \
		"${EPREFIX}"/bin/{bunzip2,bzcat,cpio,egrep,fgrep,grep,gunzip,gzip,zcat}
	use userland_BSD && dowrap "${EPREFIX}"/bin/sort
	use userland_GNU && dowrap "${EPREFIX}"/bin/{fuser,sed,uncompress}
}
