# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for a freedesktop.org Secret Service API provider"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

RDEPEND="|| (
	gnome-base/gnome-keyring
	>=kde-frameworks/kwallet-runtime-6.18.0[keyring]
	app-admin/keepassxc
)"
