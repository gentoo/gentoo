# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MLEHMANN
DIST_VERSION=7.17
inherit perl-module optfeature virtualx

DESCRIPTION="Provides a uniform interface to various event loops"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 ~riscv sparc x86 ~x86-solaris"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	dev-perl/Canary-Stability
"
PERL_RM_FILES=(
	# Requires AnyEvent::AIO form AnyEvent-AIO, not in ::gentoo
	t/12_io_ioaio.t
	# Requires Fltk from Fl, not in ::gentoo
	t/61_fltk_0{1_basic,2_signals,3_child,4_condvar,5_dns,7_io,9_multi}.t
	# Requires Cocoa::EventLoop, not in ::gentoo
	t/62_cocoa_0{1_basic,2_signals,3_child,4_condvar,5_dns,7_io,9_multi}.t
	# Requires IO::Async, not in ::gentoo
	t/66_ioasync_0{1_basic,2_signals,3_child,4_condvar,5_dns,7_io,9_multi}.t
	# Requires UV, not in ::gentoo
	t/70_uv_0{1_basic,2_signals,3_child,4_condvar,5_dns,7_io,9_multi}.t

)

pkg_postinst() {
	optfeature "improved event-loop performance" 		'>=dev-perl/EV-4.0.0'
	optfeature "improved performance of Guard objects"	'>=dev-perl/Guard-1.20.0'
	optfeature "JSON relays over AnyEvent::Handle" 		'>=dev-perl/JSON-2.90.0' '>=dev-perl/JSON-XS-2.200.0'
	optfeature "SSL support for AnyEvent::Handle" 		'>=dev-perl/Net-SSLeay-1.330.0'
	# AnyEvent::AIO
	# Async::Interrupts
}

src_test() {
	# optional:
	# - install dev-perl/glib-perl for Glib for AnyEvent::Impl::Glib
	# - install dev-perl/Event for AnyEvent::Impl::Event
	# - install dev-perl/Tk for AnyEvent::Impl::Tk
	# - install dev-perl/POE for AnyEvent::Impl::POE
	# - install dev-perl/EV for AnyEvent::Impl::EV
	if ! has "network" ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}} ||
	   ! has_version "dev-perl/glib-perl" ||
	   ! has_version "dev-perl/Event" ||
	   ! has_version "dev-perl/Tk" ||
	   ! has_version "dev-perl/POE" ||
	   ! has_version "dev-perl/EV"; then
		ewarn "This package needs network access and manually installed dependencies"
		ewarn "for comprehensive testing. For details, see:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	fi
	( # export leak guard
		export PERL_ANYEVENT_LOOP_TESTS=1

		if has "network" ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
			einfo "Network Tests Enabled"
			export PERL_ANYEVENT_NET_TESTS=1
		fi
		# This loop requires a display to even load the module
		if has_version dev-perl/Tk; then
			virtx perl-module_src_test
		else
			perl-module_src_test
		fi
	)
}
