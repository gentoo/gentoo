# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=6.511
inherit perl-module

DESCRIPTION="The only real threads in perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vanilla"

RDEPEND="
	>=dev-perl/AnyEvent-5
	>=dev-perl/Guard-0.500.0
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Storable-2.150.0
	dev-perl/common-sense
"
DEPEND="${RDEPEND}
	dev-perl/Canary-Stability
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
"

src_prepare() {
	if ! use vanilla; then
		ewarn "This release includes a 3rd party argarray patch for Perl 5.24 Compat."
		ewarn "Please do not contact upstream directly regarding problems arising from this."
		eapply "${FILESDIR}/${PV}-argarray.patch"
	fi
	perl-module_src_prepare
}
