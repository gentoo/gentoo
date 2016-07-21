# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils linux-info readme.gentoo systemd

DESCRIPTION="Scripts to support compressed swap devices or ramdisks with zram"
HOMEPAGE="https://github.com/vaeth/zram-init/"
SRC_URI="https://github.com/vaeth/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS="To use zram, activate it in your kernel and add it to default runlevel:
	rc-config add zram default
If you use systemd enable zram_swap, tmp, and/or var_tmp with systemctl.
You might need to modify /etc/modprobe.d/zram.conf"

src_prepare() {
	use prefix || sed -i \
		-e '1s"^#!/usr/bin/env sh$"#!'"${EPREFIX}/bin/sh"'"' \
		-- sbin/* || die
	epatch_user
}

src_install() {
	dosbin sbin/*
	doinitd openrc/init.d/*
	doconfd openrc/conf.d/*
	systemd_dounit systemd/system/*
	insinto /etc/modprobe.d
	doins modprobe.d/*
	insinto /usr/share/zsh/site-functions
	doins zsh/*
	readme.gentoo_create_doc
}

pkg_postinst() {
	if kernel_is -lt 3 15 ; then
		ewarn "Your kernel version is ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}"
		ewarn "sys-block/zram-init default config starting from version 3.0"
		ewarn "requires a kernel >= 3.15.0."
		ewarn "Make sure you have edited it, so it uses only functions"
		ewarn "available for your kernel version (bug 525302)."
	fi
}
