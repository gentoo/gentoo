# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="Search normal or compressed mailbox using a regular expression or dates"
HOMEPAGE="https://github.com/coppit/grepmail"
SRC_URI="mirror://cpan/authors/id/D/DC/DCOPPIT/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Date-Manip
	dev-perl/File-HomeDir
	dev-perl/Inline
	>=dev-perl/Mail-Mbox-MessageParser-1.40.01
	dev-perl/TimeDate
	virtual/perl-Digest-MD5
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Compile
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"
