# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Count Lines of Code"
HOMEPAGE="https://github.com/AlDanial/cloc"
SRC_URI="https://github.com/AlDanial/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/Algorithm-Diff
	dev-perl/Regexp-Common
	virtual/perl-Digest-MD5
	virtual/perl-Getopt-Long
	virtual/perl-File-Spec
	virtual/perl-File-Temp"

src_compile() {
	pod2man "Unix/${PN}.1.pod" > "${PN}.1" || die
}

src_install() {
	doman "${PN}.1"
	dobin "Unix/${PN}"
}
