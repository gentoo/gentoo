# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SERGEY
DIST_VERSION=0.7
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Perl extension for Sound Mixer control"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
# License note: Ambiguous
# https://rt.cpan.org/Ticket/Display.html?id=132448
LICENSE="GPL-1"

PATCHES=(
	"${FILESDIR}/${P}-volumepl.patch"
	"${FILESDIR}/${P}-clang.patch"
	"${FILESDIR}/${P}-testsuite.patch"
)

src_test() {
	local MODULES=(
		"Audio::Mixer ${DIST_VERSION}"
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
	if [[ "${AUDIO_MIXER_HW_TEST:-0}" == 0 ]]; then
		ewarn "Comprehensive testing of this module needs hardware access to mixing"
		ewarn "devices. Set AUDIO_MIXER_HW_TEST=1 in your environment if you want full"
		ewarn "coverage"
		ewarn "For details, see:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	else
		perl-module_src_test
	fi
}
