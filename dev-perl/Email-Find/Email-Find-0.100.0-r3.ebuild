# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="Find RFC 822 email addresses in plain text"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/Email-Valid-0.179.0
	dev-perl/MailTools
"

BDEPEND="${RDEPEND}"
