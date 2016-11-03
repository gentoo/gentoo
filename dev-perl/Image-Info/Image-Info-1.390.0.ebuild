# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SREZIC
DIST_VERSION=1.39
DIST_EXAMPLES=("exifdump" "imgdump")
inherit perl-module

DESCRIPTION="The Perl Image-Info Module"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=dev-perl/IO-stringy-1.01
	dev-perl/XML-LibXML
	dev-perl/XML-Simple"
RDEPEND="${DEPEND}"

src_test() {
	perl_rm_files "t/pod_cov.t" "t/pod.t"
	perl-module_src_test
}
