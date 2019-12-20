# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=YEWENBIN

inherit perl-module elisp-common

DESCRIPTION="Perl Develop Environment in Emacs"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=app-editors/emacs-23.1:*"
DEPEND="dev-perl/Module-Build
		${RDEPEND}"
myconf="--elispdir=${D}${SITELISP}/pde"

src_test() {
	local MODULES=(
		"Emacs::PDE ${PV}"
		"Emacs::PDE::Util"
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
	perl-module_src_test
}
