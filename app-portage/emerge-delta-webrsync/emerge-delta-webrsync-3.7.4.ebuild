# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="emerge-webrsync using patches to minimize bandwidth"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage"
SRC_URI="https://gitweb.gentoo.org/proj/portage.git/plain/misc/emerge-delta-webrsync?id=52d5d444ffb144911ca9b6e70b383405a8bd8af6 -> ${P}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="
	app-shells/bash
	|| (
		>=sys-apps/portage-2.1.10
		sys-apps/portage-mgorny
	)
	>=dev-util/diffball-0.6.5"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${P}" "${WORKDIR}/" || die
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
