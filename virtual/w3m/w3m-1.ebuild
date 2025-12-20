# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for the w3m web browser"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="|| (
		www-client/w3m
		www-client/w3mmee
	)"
