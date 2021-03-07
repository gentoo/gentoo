# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TURNSTEP
DIST_VERSION=1.2.5
inherit perl-module eutils

DESCRIPTION="Safer access to your database through a DBI database handle"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
LICENSE="BSD-2"

RDEPEND="dev-perl/DBI
	dev-perl/DBD-Pg"
DEPEND="${RDEPEND}"

src_test() {
	perl_rm_files t/02perlcritic.t
	if [[ -z "${DBI_DSN}" ]]; then
		ewarn "Comprehensive testing of this package requires some manual configuration."
		ewarn "For details, see:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/DBIx-Safe"
	fi
	perl-module_src_test
}
