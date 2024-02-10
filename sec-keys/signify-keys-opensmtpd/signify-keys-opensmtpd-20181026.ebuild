# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P#signify-keys-}"
DESCRIPTION="Signify keys used to sign OpenSMTPD portable releases"
HOMEPAGE="https://www.opensmtpd.org/"
SRC_URI="https://www.opensmtpd.org/archives/${MY_P}.pub"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	insinto /usr/share/signify-keys
	newins "${DISTDIR}"/${MY_P}.pub opensmtpd.pub
}
