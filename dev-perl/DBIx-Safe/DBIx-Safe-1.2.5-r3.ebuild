# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TURNSTEP
DIST_VERSION=1.2.5
inherit perl-module

DESCRIPTION="Safer access to your database through a DBI database handle"

SLOT="0"
KEYWORDS="amd64 x86"

# Note, may be incorrect:
#  https://bugs.gentoo.org/433601
LICENSE="BSD-2"

RDEPEND="
	>=dev-perl/DBI-1.490.0
	>=dev-perl/DBD-Pg-1.490.0
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=(
	t/02perlcritic.t
)

src_test() {
	if [[ -z "${DBI_DSN}" ]]; then
		ewarn "Comprehensive testing of this package requires some manual configuration."
		ewarn "For details, see:"
		ewarn " https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	fi
	perl-module_src_test
}
