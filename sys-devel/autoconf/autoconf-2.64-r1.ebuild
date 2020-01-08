# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-autoconf

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"
IUSE=""

DEPEND=">=sys-devel/m4-1.4.6
	dev-lang/perl"
RDEPEND="${DEPEND}
	!~sys-devel/${P}:2.5
	>=sys-devel/autoconf-wrapper-13"

PATCHES=(
		"${FILESDIR}"/${PN}-2.69-perl-5.26.patch
		"${FILESDIR}"/${PN}-2.69-perl-5.26-2.patch
)
