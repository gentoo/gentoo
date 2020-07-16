# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator perl-module

MY_P="${PN}-$(delete_version_separator 2)"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Search normal or compressed mailbox using a regular expression or dates"
HOMEPAGE="https://github.com/coppit/grepmail"
SRC_URI="mirror://sourceforge/grepmail/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Inline
	dev-perl/TimeDate
	dev-perl/Date-Manip
	virtual/perl-Digest-MD5
	>=dev-perl/Mail-Mbox-MessageParser-1.40.01
"
DEPEND="${RDEPEND}
"
#	test? ( dev-perl/Mail-Mbox-MessageParser )

# 100% failure on running
DIST_TEST="skip"

PATCHES=(
	"${FILESDIR}"/5.30.33-fix_nonexistent_mailbox_test.patch
	"${FILESDIR}"/5.30.33-midnight.patch
)

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
