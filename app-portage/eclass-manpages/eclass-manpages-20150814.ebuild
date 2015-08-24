# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="collection of Gentoo eclass manpages"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

S=${WORKDIR}

genit() {
	local e=${1:-${ECLASSDIR}}
	einfo "Generating man pages from: ${e}"
	# Need `bash` because the .sh isn't +x on the servers #451352
	env ECLASSDIR=${e} bash "${FILESDIR}"/eclass-to-manpage.sh || die
}

src_compile() {
	# First process any eclasses found in overlays.  Then process
	# the main eclassdir last so that its output will clobber anything
	# that might have come from overlays.  Main tree wins!
	local o e
	for o in ${PORTDIR_OVERLAY} ; do
		e="${o}/eclass"
		[[ -d ${e} ]] || continue
		genit "${e}" || die
	done
	genit || die
}

src_install() {
	doman *.5
}
