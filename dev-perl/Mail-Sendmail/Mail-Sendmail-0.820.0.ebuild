# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.82
inherit perl-module

DESCRIPTION="Simple platform independent mailer"

SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="dev-perl/Sys-Hostname-Long"

PATCHES=(
	"${FILESDIR}"/${PN}-0.820.0-fix-version.patch
)

src_test() {
	local MODULES=(
		"Mail::Sendmail ${DIST_VERSION}"
	)
	local failed=()

	local dep
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
		perl -Mblib="${S}" -M"${dep} ()" -e1
		eend $? || failed+=( "${dep}" )
	done

	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi

	if has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		perl-module_src_test
	else
		ewarn "Network tests disabled without DIST_TEST_OVERRIDE=~network"
	fi
}
