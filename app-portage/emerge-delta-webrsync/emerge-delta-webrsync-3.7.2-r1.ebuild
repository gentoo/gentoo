# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
DESCRIPTION="emerge-webrsync using patches to minimize bandwidth"
HOMEPAGE="https://www.gentoo.org/proj/en/portage/index.xml"
SRC_URI="https://raw.githubusercontent.com/gentoo/portage/779a9e686d89e31af43e33b1163b01aeff65d7ea/misc/emerge-delta-webrsync -> ${P}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ppc ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="
	app-shells/bash
	>=sys-apps/portage-2.1.10
	>=dev-util/diffball-0.6.5"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${P}" "${WORKDIR}/" || die
}

src_prepare() {
	# Remove premature `rm -fr "${TMPDIR}"` for bug #506192.
	sed -e '334,336d' -i ${P} || die
}

src_install() {
	newbin ${P} ${PN}
	keepdir /var/delta-webrsync
	fperms 0770 /var/delta-webrsync
}

pkg_preinst() {
	# Failure here is non-fatal, since the "portage" group
	# doesn't necessarily exist on prefix systems.
	chgrp portage "${ED}"/var/delta-webrsync 2>/dev/null
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] && \
		! has_version app-arch/tarsync ; then
		elog "For maximum emerge-delta-webrsync" \
			"performance, install app-arch/tarsync."
	fi
}
