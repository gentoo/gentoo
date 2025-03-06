# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_NAME=gettext
DIST_AUTHOR=PVANDRY
inherit perl-module

DESCRIPTION="A Perl module for accessing the GNU locale utilities"

COMMIT="0e6b2fb24521e8ea1f6720641412ab31b3301071"
SRC_URI="
	https://github.com/vandry/Perl-Locale-gettext/archive/${COMMIT}.tar.gz
		-> Perl-Locale-gettext-${COMMIT}.tar.gz
"
S="${WORKDIR}/Perl-Locale-gettext-${COMMIT}"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	sys-devel/gettext
"
BDEPEND="${RDEPEND}
	>=dev-perl/Config-AutoConf-0.313
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
"

PATCHES=(
	"${FILESDIR}/${PN}-1.70.0-tests.patch"
	"${FILESDIR}/${PN}-1.70.0_p20181130-config-log.patch"
)
