# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SREZIC
DIST_VERSION=1.42
DIST_EXAMPLES=("exifdump" "imgdump")
inherit perl-module

DESCRIPTION="The Perl Image-Info Module"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/IO-stringy-1.01
	dev-perl/XML-LibXML
	dev-perl/XML-Simple
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=( "t/pod_cov.t" "t/pod.t" )
