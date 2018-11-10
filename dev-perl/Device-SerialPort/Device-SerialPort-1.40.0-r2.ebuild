# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=COOK
DIST_VERSION=1.04
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="A Serial port Perl Module"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc sparc x86"
IUSE=""

#From the module:
# If you run 'make test', you must make sure that nothing is plugged
# into '/dev/ttyS1'!
# Doesn't sound wise to enable SRC_TEST="do" - mcummings

src_configure() {
	myconf=()
	[[ -n "${DEVICE_SERIALPORT_PORT}" ]] && myconf+=( "TESTPORT=${DEVICE_SERIALPORT_PORT}" )
	perl-module_src_configure
}
src_test() {
	local MODULES=(
		"Device::SerialPort ${DIST_VERSION}"
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
	if [[ -n "${DEVICE_SERIALPORT_PORT}" ]]; then
		DIST_TEST="do"; # Parallel testing a serial port sounds unsmart.
		perl-module_src_test;
	else
		ewarn "Functional tests are disabled without manual intervention."
		ewarn "For details, read:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Device-SerialPort"
	fi
}
