# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Linux Health Checker"
HOMEPAGE="http://lnxhc.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-lang/perl-5.8"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2-usrlocal.patch
	"${FILESDIR}"/${PN}-1.2-ifconfig-path.patch
)
