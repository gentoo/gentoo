# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gentoo Package Manager Specification"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Package_Manager_Specification"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/pms-${PV}-prebuilt.tar.xz"
S="${WORKDIR}/pms-${PV}"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="html"

RDEPEND="!app-doc/pms"

src_install() {
	dodoc pms.pdf eapi-cheatsheet.pdf
	if use html; then
		docinto html
		dodoc *.html pms.css
		dosym {..,/usr/share/doc/${PF}/html}/eapi-cheatsheet.pdf
	fi
}
