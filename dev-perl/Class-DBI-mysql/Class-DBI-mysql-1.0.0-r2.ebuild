# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TMTM
DIST_VERSION=1.00
inherit perl-module

DESCRIPTION="Extensions to Class::DBI for MySQL"

LICENSE="|| ( GPL-3 GPL-2 )" # GPL-2+
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Class-DBI
	dev-perl/DBD-mysql"
DEPEND="${RDEPEND}"

src_test() {
	local MODULES=(
		"Class::DBI::mysql ${DIST_VERSION}"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}" -M"${dep} ()" -e1
		eend $? || failed+=( "$dep" )
	done
	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi
	if [[ -n "${DBD_MYSQL_DBNAME}" ]]; then
		perl_rm_files t/pod-coverage.t t/pod.t
		perl-module_src_test
	else
		ewarn "Functional testing of this package requires user intervention."
		ewarn "For details, see:"
		ewarn "https://wiki.gentoo.org/Project:Perl/maint-notes/dev-perl/Class-DBI-mysql"
	fi
}
