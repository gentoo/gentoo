# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Signify keys used to sign OpenSMTPD portable releases"
HOMEPAGE="https://www.opensmtpd.org/"
SRC_URI="https://www.opensmtpd.org/archives/opensmtpd-${PV}.pub -> opensmtpd-${PV}.pub"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	insinto /usr/share/signify-keys
	doins "${DISTDIR}/opensmtpd-${PV}.pub"
}
