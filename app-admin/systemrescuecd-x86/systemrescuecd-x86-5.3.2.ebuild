# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The .iso image of SystemRescueCD rescue disk, x86 (+ amd64) variant"
HOMEPAGE="http://www.sysresccd.org/"
# Large ISO mirroring explicitly approved by infra in bug #588766
SRC_URI="mirror://sourceforge/systemrescuecd/sysresccd-${PN#*-}/${PV}/${P}.iso"

LICENSE="AGPL-3 Apache-2.0 APSL-2 Artistic Artistic-2 Atmel bh-luxi BitstreamVera boehm-gc BSD BSD-1 BSD-2 BSD-4 BZIP2 CC0-1.0 CC-BY-3.0 CC-BY-SA-3.0 CC-PD CDDL-Schily Clarified-Artistic CPL-1.0 EPL-1.0 FDL-1.1+ FDL-1.2+ FDL-1.3 FDL-1.3+ FLTK freedist FTL GPL-1+ GPL-2 GPL-2+ GPL-2-with-font-exception GPL-3 GPL-3+ HPND icu IJG Info-ZIP inner-net ipw2100-fw ipw2200-fw ISC Kermit LGPL-2 LGPL-2+ LGPL-2.1 LGPL-2.1+ LGPL-3 LGPL-3+ libpng linux-firmware lsof man-pages man-pages-posix-2013 MIT MPL-1.1 MPL-2.0 netcat ngrep no-source-code NPL-1.1 OFL-1.1 Old-MIT openafs-krb5-a OPENLDAP openssl PCRE PSF-2 PSF-2.4 public-domain rc rdisc RSA Sleepycat SMAIL SSLeay symlinks tcltk tcp_wrappers_license unRAR UoI-NCSA vim wxWinLL-3 ZLIB ZSH || ( AFL-2.1 GPL-2 ) || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) || ( Ruby BSD-2 ) || ( Ruby GPL-2 ) || ( Ruby MIT ) || ( Ruby-BSD BSD-2 )"
SLOT="${PV}"
KEYWORDS="amd64 x86"
IUSE="+isohybrid"

DEPEND="isohybrid? ( >=sys-boot/syslinux-4 )"

S=${WORKDIR}

RESTRICT="bindist mirror"

src_install() {
	insinto "/usr/share/${PN%-*}"
	doins "${DISTDIR}/${P}.iso"

	if use isohybrid; then
		set -- isohybrid -u "${ED}usr/share/${PN%-*}/${P}.iso"
		echo "${@}"
		"${@}" || die "${*} failed"
	fi
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
