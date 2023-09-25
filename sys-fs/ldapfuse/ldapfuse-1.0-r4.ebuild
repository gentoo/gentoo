# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual filesystem for FUSE which allows navigation of an LDAP tree"
HOMEPAGE="https://sourceforge.net/projects/ldapfuse/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	net-nds/openldap:=
	sys-fs/fuse:0
	>=sys-libs/libhx-3.12:="
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig"

DOCS=( doc/changelog.txt doc/rfcs.txt )
