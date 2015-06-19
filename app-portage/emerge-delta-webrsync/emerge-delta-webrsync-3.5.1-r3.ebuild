# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/emerge-delta-webrsync/emerge-delta-webrsync-3.5.1-r3.ebuild,v 1.4 2012/05/15 01:17:37 zmedico Exp $

inherit eutils

DESCRIPTION="emerge-webrsync using patches to minimize bandwidth"
HOMEPAGE="http://www.gentoo.org/proj/en/portage/index.xml"
SRC_URI="mirror://gentoo/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ~ppc ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=">=sys-apps/portage-2.1.1-r1
	>=dev-util/diffball-0.6.5"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${P}" "${WORKDIR}/" || die "failed cping ${P}"
	epatch "${FILESDIR}"/3.5.1-metadata.patch
	epatch "${FILESDIR}"/3.5.1-md5sum.patch
	epatch "${FILESDIR}"/3.5.1-post_sync.patch
	# Support years after 2010.
	sed 's/portage-200\*/portage-2[[:digit:]][[:digit:]][[:digit:]][[:digit:]][[:digit:]][[:digit:]][[:digit:]]/g' \
		-i $P || die "sed failed"
	sed "s:-c'import portage; print \\(.*\\)\\()')\\)$:-c 'import portage, sys; sys.stdout.write(\\1)\\2:" \
		-i $P || die "sed failed"
}

src_compile() { :; }

src_install() {
	newbin ${P} ${PN} || die "failed copying ${P}"
	keepdir /var/delta-webrsync
	fperms 0770 /var/delta-webrsync
}

pkg_preinst() {
	chgrp portage "${D}"/var/delta-webrsync
	has_version "$CATEGORY/$PN"
	WAS_PREVIOUSLY_INSTALLED=$?
}

pkg_postinst() {
	if [[ $WAS_PREVIOUSLY_INSTALLED != 0 ]] && \
		! has_version app-arch/tarsync ; then
		elog "For maximum emerge-delta-webrsync" \
			"performance, install app-arch/tarsync."
	fi
}
