# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DELTA_WEBRSYNC_COMMIT="591f0826a15e437eb02e2eddf8ed1487b05f5e94"

DESCRIPTION="emerge-webrsync using patches to minimize bandwidth"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage"
SRC_URI="https://gitweb.gentoo.org/proj/portage.git/plain/misc/emerge-delta-webrsync?id=${DELTA_WEBRSYNC_COMMIT} -> ${P}"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"

RDEPEND="
	app-shells/bash
	>=dev-util/diffball-0.6.5
	>=sys-apps/portage-3.0.49
"

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
