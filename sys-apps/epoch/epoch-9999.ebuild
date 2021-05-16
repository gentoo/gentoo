# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit epatch linux-info git-r3

MY_PV="${PV/rc/RC}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="An init system, a /sbin/init replacement; designed for simplicity"
HOMEPAGE="http://universe2.us/epoch.html"
EGIT_REPO_URI="https://github.com/Subsentient/epoch.git"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""

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
	newins "${FILESDIR}"/${PN}-1.0-epoch.conf epoch.conf
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
