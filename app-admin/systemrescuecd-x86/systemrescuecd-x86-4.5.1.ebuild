# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="The .iso image of SystemRescueCD rescue disk, x86 (+ amd64) variant"
HOMEPAGE="http://www.sysresccd.org/"
SRC_URI="mirror://sourceforge/systemrescuecd/sysresccd-${PN#*-}/${PV}/${P}.iso"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

RESTRICT="mirror"

src_install() {
	insinto "/usr/share/${PN%-*}"
	doins "${DISTDIR}/${P}.iso"
}

pkg_postinst() {
	local f=${EROOT%/}/usr/share/${PN%-*}/${PN}-newest.iso

	# no version newer than ours? we're the newest!
	if ! has_version ">${CATEGORY}/${PF}"; then
		ln -f -s -v "${P}.iso" "${f}" || die
	fi
}

pkg_postrm() {
	local f=${EROOT%/}/usr/share/${PN%-*}/${PN}-newest.iso

	# if there is no version newer than ours installed
	if ! has_version ">${CATEGORY}/${PF}"; then
		# and we are truly and completely uninstalled...
		if [[ ! ${REPLACED_BY_VERSION} ]]; then
			# then find an older version to set the symlink to
			local newest_version=$(best_version "<${CATEGORY}/${PF}")

			if [[ ${newest_version} ]]; then
				# update the symlink
				ln -f -s -v "${newest_version%-r*}.iso" "${f}" || die
			else
				# last version removed? clean up the symlink
				rm -v "${f}" || die
				# and the parent directory
				rmdir "${f%/*}" || die
			fi
		fi
	fi
}
