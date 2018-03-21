# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BMC
DIST_VERSION=1.5
inherit perl-module

DESCRIPTION="Automate interaction with bugzilla"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-perl/WWW-Mechanize-1.300.0
	>=dev-perl/Params-Validate-0.880.0
	>=dev-perl/Crypt-SSLeay-0.570.0
	>=dev-perl/Class-MethodMaker-1.80.0"
DEPEND="${RDEPEND}"

src_prepare() {
	perl-module_src_prepare
	mkdir "${S}"/lib || die "Can't mkdir lib"
	cp -r "${S}"/{WWW,lib} || die "Can't copy WWW"
}

# Network tests are broken
DIST_TEST="skip"
src_test() {
	local MODULES=(
		"WWW::Bugzilla ${DIST_VERSION}"
		"WWW::Bugzilla::Search 0.1"
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
