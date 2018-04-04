# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SETHJ
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Perl interface to *NIX digital audio device"

SLOT="0"
KEYWORDS="amd64 sparc ~x86"
IUSE=""

src_test() {
	local MODULES=(
		"Audio::DSP ${DIST_VERSION}"
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
	if [[ "${AUDIO_DSP_HW_TEST:-0}" == 0 ]]; then
		ewarn "Comprehensive testing of this module needs hardware access to dsp"
		ewarn "devices. Set AUDIO_DSP_HW_TEST=1 in your environment if you want full"
		ewarn "coverage"
		ewarn "For details, see:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Audio-DSP"
	else
		perl-module_src_test
	fi
}
