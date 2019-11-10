# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Stub ebuild to help migrate to newer package name"
HOMEPAGE="http://www.openwall.com/passwdqc/"

LICENSE="Openwall BSD public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"

DEPEND="sys-auth/passwdqc[pam]"
RDEPEND="${DEPEND}"
