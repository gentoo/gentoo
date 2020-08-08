# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=YEWENBIN
DIST_VERSION="v${PV}"
inherit perl-module elisp-common

DESCRIPTION="Perl Develop Environment in Emacs"
# Some elisp files are GPL-2+
# Some templates are FDL-1.1+
LICENSE="|| ( Artistic GPL-1+ ) GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND=">=app-editors/emacs-23.1:*"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
"
src_configure() {
	myconf="--elispdir=${D}${SITELISP}/pde"
	perl-module_src_configure
}
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
