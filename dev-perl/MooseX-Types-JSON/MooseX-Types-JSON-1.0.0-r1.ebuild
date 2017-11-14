# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MILA
DIST_VERSION=1.00
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="JSON datatype for Moose"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/JSON
	>=dev-perl/JSON-XS-2.00
	dev-perl/Moose
	dev-perl/MooseX-Types
"
DEPEND="${RDEPEND}"

src_test() {
	perl_rm_files t/00-pod.t t/release-*.t
	perl-module_src_test
}
