# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for checkpassword compatible applications"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~m68k ~mips ppc64 ~s390 sparc x86"

RDEPEND="|| (
	net-mail/checkpassword
	net-mail/checkpassword-pam
	net-mail/vpopmail
)"
