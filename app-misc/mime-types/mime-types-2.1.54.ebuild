# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV//./-}
DESCRIPTION="Provides /etc/mime.types file"
HOMEPAGE="https://github.com/InfrastructureServices/mailcap"
SRC_URI="https://github.com/InfrastructureServices/mailcap/archive/refs/tags/r${MY_PV}.tar.gz"

S="${WORKDIR}/mailcap-r${MY_PV}"
LICENSE="public-domain MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="nginx"

src_install() {
	insinto /etc
	doins mime.types
	if use nginx; then
		insinto /etc/nginx
		doins mime.types.nginx
	fi
}
