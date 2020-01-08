# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for cron"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"

RDEPEND="|| ( sys-process/cronie
		sys-process/vixie-cron
		sys-process/bcron
		sys-process/dcron
		sys-process/fcron
		sys-process/systemd-cron )"
