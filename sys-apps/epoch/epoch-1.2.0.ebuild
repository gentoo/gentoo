# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/epoch/epoch-1.2.0.ebuild,v 1.2 2015/02/13 11:08:35 amynka Exp $

EAPI="5"

inherit eutils linux-info

MY_PV="${PV/rc/RC}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="An init system, a /sbin/init replacement; designed for simplicity"
HOMEPAGE="http://universe2.us/epoch.html"
SRC_URI="https://github.com/Subsentient/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	local CONFIG_CHECK="~PROC_FS"

	[[ ${MERGE_TYPE} != buildonly ]] && check_extra_config
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0-fix-CFLAGS.patch
}

src_compile() {
	NEED_EMPTY_CFLAGS=1 sh ./buildepoch.sh || die "Cannot build epoch."
}

newepochins() {
	local type="$1"

	cd ${type} || die "Cannot change directory."
	for file in * ; do
		if [[ "${file}" != "epoch" ]] ; then
			new${type} ${file} epoch-${file}
		fi
	done
	cd .. || die "Cannot change directory."
}

src_install() {
	cd built || die "Cannot change directory."

	dosbin sbin/epoch

	# For now, rename to epoch-* until we can blend in with a standard approach.
	newepochins bin
	newepochins sbin

	insinto /etc/epoch/
	newins "${FILESDIR}"/${PN}-1.0_rc1-epoch.conf epoch.conf
}

pkg_postinst() {
	elog "Make sure to provide /run and /tmp tmpfs mounts using /etc/fstab."
	elog ""
	elog "An example epoch configuration is provided at /etc/epoch/epoch.conf"
	elog "which starts a minimal needed to use Gentoo."
	elog ""
	elog "To use epoch, add this kernel parameter: init=/usr/sbin/epoch-init"
	elog ""
	elog "Additional information about epoch is available at"
	elog "${HOMEPAGE} and configuration documentation at"
	elog "http://universe2.us/epochconfig.html which is useful reading material."
	elog ""
	elog "Its author Subsentient can be contacted at #epoch on irc.freenode.net."
}
