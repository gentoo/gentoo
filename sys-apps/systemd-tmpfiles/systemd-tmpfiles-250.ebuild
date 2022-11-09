# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual package to depend on sys-apps/systemd-utils"
HOMEPAGE="https://systemd.io/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="sys-apps/systemd-utils[tmpfiles]"
