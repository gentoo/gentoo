# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${P/-x86/}
DESCRIPTION="The .iso image of SystemRescueCD rescue disk, amd64 variant"
HOMEPAGE="http://www.sysresccd.org/"
SRC_URI="https://osdn.net/projects/systemrescuecd/storage/releases/${PV}/${MY_P}.iso"

LICENSE="Apache-1.0 Apache-2.0 Artistic Artistic-2 BEER-WARE BSD BSD-2 BSD-4 CC0-1.0 CC-BY-SA-3.0 FDL-1.3+ GPL-2 GPL-2+ GPL-3+ icu ISC JasPer2.0 LGPL-2+ LGPL-2.1+ LGPL-3+ linux-firmware MaxMind2 MIT MPL-1.1 MPL-2.0 no-source-code OFL Old-MIT OPENLDAP openssl PSF-2 public-domain Sleepycat unRAR UoI-NCSA vim ZLIB"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+isohybrid"
RESTRICT="bindist mirror"

DEPEND="isohybrid? ( >=sys-boot/syslinux-4 )"

S=${WORKDIR}

pkg_pretend() {
	ewarn "Please note that starting with version 6.0.0, upstream has switched"
	ewarn "to Arch Linux as base of their distribution, and running on 32-bit"
	ewarn "systems is no longer supported."
}

src_unpack() { :; }

src_install() {
	insinto "/usr/share/${PN%-*}"
	doins "${DISTDIR}/${MY_P}.iso"

	if use isohybrid; then
		set -- isohybrid -u "${ED%/}/usr/share/${PN%-*}/${MY_P}.iso"
		echo "${@}"
		"${@}" || die "${*} failed"
	fi
}

pkg_postinst() {
	local f=${EROOT%/}/usr/share/${PN%-*}/${PN}-newest.iso

	# no version newer than ours? we're the newest!
	if ! has_version ">${CATEGORY}/${PF}"; then
		ln -f -s -v "${MY_P}.iso" "${f}" || die
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
