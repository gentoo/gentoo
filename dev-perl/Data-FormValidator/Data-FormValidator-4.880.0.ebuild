# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DFARRELL
DIST_VERSION=4.88
inherit perl-module

DESCRIPTION="Validates user input (usually from an HTML form) based on input profile"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Image-Size
	>=dev-perl/Date-Calc-5.0
	>=dev-perl/File-MMagic-1.170.0
	>=dev-perl/MIME-Types-1.5.0
	>=dev-perl/Regexp-Common-0.30.0
	dev-perl/Email-Valid
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
PATCHES=( "${FILESDIR}/${P}-skip-readme-pod.patch" )
src_test() {
	local i;
	elog "Install the following dependencies for comprehensive tests:"
	i="$(if has_version '>=dev-perl/CGI-4.350.0'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i >=dev-perl/CGI-4.350.0"
	elog "     - Test interop with CGI.pm as an input source";
	i="$(if has_version 'dev-perl/CGI-Simple'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i dev-perl/CGI-Simple"
	elog "     - Test interop with CGI::Simple as an input source";
	i="$(if has_version 'dev-perl/Template-Toolkit'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i dev-perl/Template-Toolkit"
	elog "     - Test Template.pm can format Data::FormValidator objects";
	elog
	perl_rm_files t/pod.t
	local MODULES=(
		"Data::FormValidator ${DIST_VERSION}"
		"Data::FormValidator::Constraints ${DIST_VERSION}"
		"Data::FormValidator::Constraints::Dates ${DIST_VERSION}"
		"Data::FormValidator::Constraints::Upload ${DIST_VERSION}"
		"Data::FormValidator::ConstraintsFactory ${DIST_VERSION}"
		"Data::FormValidator::Filters ${DIST_VERSION}"
		"Data::FormValidator::Results ${DIST_VERSION}"
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
