# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit readme.gentoo-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zfsonlinux/${PN}.git"
else
	MY_P="${PN}-upstream-${PV}"
	SRC_URI="https://github.com/zfsonlinux/${PN}/archive/upstream/${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="ZFS Automatic Snapshot Service for Linux"
HOMEPAGE="https://github.com/zfsonlinux/zfs-auto-snapshot"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+default-exclude"

RDEPEND="sys-fs/zfs
	virtual/cron"

src_install() {
	if use default-exclude; then
		for cronfile in etc/"${PN}".cron.{daily,hourly,monthly,weekly}; do
			sed -i "s/\(^exec ${PN}\)/\1 --default-exclude/" "${cronfile}" || die
		done
		sed -i "s/\(; ${PN}\)/\1 --default-exclude/" etc/"${PN}".cron.frequent || die
	fi
	readme.gentoo_create_doc
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
}

pkg_postinst() {
	readme.gentoo_print_elog

	if ! use default-exclude; then
		ewarn "snapshots are enabled by default for ALL zfs datasets"
		ewarn "set com.sun:auto-snapshot=false or enable 'default-exclude' flag"
		elog
	fi

	if has_version sys-process/fcron; then
		ewarn "frequent snapshot may not work if you are using fcron"
		ewarn "you should add frequent job to crontab manually"
	fi
}
