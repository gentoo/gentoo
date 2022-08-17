# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix readme.gentoo-r1 systemd

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zfsonlinux/${PN}.git"
else
	MY_P="${PN}-upstream-${PV}"
	SRC_URI="https://github.com/zfsonlinux/${PN}/archive/upstream/${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="ZFS Automatic Snapshot Service for Linux"
HOMEPAGE="https://github.com/zfsonlinux/zfs-auto-snapshot"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+cron +default-exclude systemd"

RDEPEND="
	sys-apps/which
	sys-fs/zfs
	!systemd? ( virtual/cron )
"

REQUIRED_USE="!systemd? ( cron )"

src_install() {
	if use default-exclude; then
		for cronfile in etc/"${PN}".cron.{daily,hourly,monthly,weekly}; do
			sed -i "s/\(^exec ${PN}\)/\1 --default-exclude/" "${cronfile}" || die
		done
		sed -i "s/\(; ${PN}\)/\1 --default-exclude/" etc/"${PN}".cron.frequent || die
	fi
	readme.gentoo_create_doc
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install

	local exclude unit
	exclude="$(usev default-exclude)"
	for unit in "${PN}"{-daily,-frequent,-hourly,-monthly,-weekly}.service; do
		cp "${FILESDIR}/${unit}" "${T}/${unit}" || die
		eprefixify "${T}/${unit}"
		sed -i "s/@DEFAULT_EXCLUDE@/${exclude:+--default-exclude}/g" "${T}/${unit}" || die
		systemd_dounit "${T}/${unit}"
	done
	for unit in "${PN}"{-daily,-frequent,-hourly,-monthly,-weekly}.timer; do
		systemd_dounit "${FILESDIR}/${unit}"
	done
	systemd_dounit "${FILESDIR}/${PN}.target"

	if ! use cron; then
		ebegin "removing cron files from installation image"
		rm -rfv "${ED}/etc" || die
		eend "$?"
	fi
}

pkg_postinst() {
	readme.gentoo_print_elog

	if ! use default-exclude; then
		ewarn "snapshots are enabled by default for ALL zfs datasets"
		ewarn "set com.sun:auto-snapshot=false or enable 'default-exclude' flag"
		elog
	fi

	if use cron && has_version sys-process/fcron; then
		ewarn "frequent snapshot may not work if you are using fcron"
		ewarn "you should add frequent job to crontab manually"
	fi

	if use cron; then
		if systemd_is_booted || has_version sys-apps/systemd; then
			echo
			ewarn "Both 'cron' and 'systemd' flags are enabled."
			ewarn "So both ${PN}.target and cron files were installed."
			ewarn "Please don't use 2 implementations at the same time."
			ewarn "Cronjobs are usually enabled by default via /etc/cron.* jobs"
			ewarn "If you want to use systemd ${PN}.target timers"
			ewarn "disable 'cron' flag and reinstall ${PN}"
			echo
		fi
	fi
}
