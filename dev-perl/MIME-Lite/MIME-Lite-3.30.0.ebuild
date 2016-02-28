# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=3.030
inherit perl-module

DESCRIPTION="Low-calorie MIME generator"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="minimal"

PATCHES=("${FILESDIR}/${DIST_VERSION}-makefilepl.patch")
PERL_RM_FILES=(
	"t/pod.t"
	"t/pod-coverage.t"
)
# MIME::QuotedPrint -> perl-MIME-Base64
# Mail::Address -> MailTools
RDEPEND="
	!minimal? (
		virtual/perl-MIME-Base64
		>=dev-perl/MIME-Types-1.280.0
		>=dev-perl/MailTools-1.620.0
	)
	dev-perl/Email-Date-Format
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_install() {
	perl-module_src_install
	insinto /usr/share/${PN}
	doins -r contrib
}
