# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs multilib-minimal

MIN_PV="$(ver_cut 2)"

DESCRIPTION="Netscape Portable Runtime"
HOMEPAGE="https://www.mozilla.org/projects/nspr/"
SRC_URI="https://archive.mozilla.org/pub/nspr/releases/v${PV}/src/${P}.tar.gz"

LICENSE="|| ( MPL-2.0 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="debug"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/nspr-config
)

PATCHES=(
	"${FILESDIR}"/${PN}-4.23-prtime.patch
	"${FILESDIR}"/${PN}-4.7.1-solaris.patch
	"${FILESDIR}"/${PN}-4.10.6-solaris.patch
	"${FILESDIR}"/${PN}-4.8.4-darwin-install_name.patch
	"${FILESDIR}"/${PN}-4.8.9-link-flags.patch
	# We do not need to pass -L$libdir via nspr-config --libs
	"${FILESDIR}"/${PN}-4.9.5_nspr_config.patch
)

QA_CONFIGURE_OPTIONS="--disable-static"

src_prepare() {
	cd "${S}"/nspr || die

	default

	use elibc_musl && eapply "${FILESDIR}"/${PN}-4.21-ipv6-musl-support.patch

	# rename configure.in to configure.ac for new autotools compatibility
	if [[ -e "${S}"/nspr/configure.in ]] ; then
		einfo "Renaming configure.in to configure.ac"
		mv "${S}"/nspr/configure.{in,ac} || die
	else
		elog "configure.in rename logic can be removed from ebuild."
	fi

	# We must run eautoconf to regenerate configure
	eautoconf

	# make sure it won't find Perl out of Prefix
	sed -i -e "s/perl5//g" "${S}"/nspr/configure || die

	# Respect LDFLAGS
	sed -i -e 's/\$(MKSHLIB) \$(OBJS)/\$(MKSHLIB) \$(LDFLAGS) \$(OBJS)/g' \
		"${S}"/nspr/config/rules.mk || die
}

multilib_src_configure() {
	# We use the standard BUILD_xxx but nspr uses HOST_xxx
	tc-export_build_env BUILD_CC
	export HOST_CC=${BUILD_CC} HOST_CFLAGS=${BUILD_CFLAGS} HOST_LDFLAGS=${BUILD_LDFLAGS}
	tc-export AR AS CC CXX RANLIB
	[[ ${CBUILD} != ${CHOST} ]] \
		&& export CROSS_COMPILE=1 \
		|| unset CROSS_COMPILE

	local myconf=(
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		$(use_enable debug)
		$(use_enable !debug optimize)
	)

	# The configure has some fancy --enable-{{n,x}32,64bit} switches
	# that trigger some code conditional to platform & arch. This really
	# matters for the few common arches (x86, ppc) but we pass a little
	# more of them to be future-proof.

	# use ABI first, this will work for most cases
	case "${ABI}" in
		alpha|arm|hppa|m68k|o32|ppc|s390|sh|sparc|x86) ;;
		n32) myconf+=( --enable-n32 );;
		x32) myconf+=( --enable-x32 );;
		s390x|*64) myconf+=( --enable-64bit );;
		default) # no abi actually set, fall back to old check
			einfo "Running a short build test to determine 64bit'ness"
			echo > "${T}"/test.c || die
			${CC} ${CFLAGS} ${CPPFLAGS} -c "${T}"/test.c -o "${T}"/test.o || die
			case $(file "${T}"/test.o) in
				*32-bit*x86-64*) myconf+=( --enable-x32 );;
				*64-bit*|*ppc64*|*x86_64*) myconf+=( --enable-64bit );;
				*32-bit*|*ppc*|*i386*) ;;
				*) die "Failed to detect whether your arch is 64bits or 32bits, disable distcc if you're using it, please";;
			esac ;;
		*) ;;
	esac

	# Ancient autoconf needs help finding the right tools.
	LC_ALL="C" ECONF_SOURCE="${S}/nspr" \
	ac_cv_path_AR="${AR}" \
	ac_cv_path_AS="${AS}" \
	econf "${myconf[@]}"
}

multilib_src_test() {
	# https://firefox-source-docs.mozilla.org/nspr/running_nspr_tests.html
	cd "${BUILD_DIR}/pr/tests" || die
	einfo "Building tests"
	emake

	einfo "Running test suite"
	../../../${P}/${PN}/pr/tests/runtests.pl | tee "${T}"/${ABI}-tests.log

	# Needed to check if runtests.pl itself or the tee (somehow) failed
	# (can't use die with pipes to check each component)
	[[ ${PIPESTATUS[@]} == "0 0" ]] || die "Tests failed to run!"

	local known_failures=(
		# network-sandbox related?
		cltsrv
		# network-sandbox related?
		gethost
	)

	local known_failure
	for known_failure in "${known_failures[@]}" ; do
		sed -i -e "/${known_failure}.*FAILED/d" "${T}"/${ABI}-tests.log || die
	done

	# But to actually check the test results, we examine the log.
	if grep -q "FAILED" "${T}"/${ABI}-tests.log ; then
		die "Test failure for ${ABI}!"
	fi
}

multilib_src_install() {
	# Their build system is royally confusing, as usual
	MINOR_VERSION=${MIN_PV} # Used for .so version
	emake DESTDIR="${D}" install

	einfo "removing static libraries as upstream has requested!"
	rm "${ED}"/usr/$(get_libdir)/*.a || die "failed to remove static libraries."

	# install nspr-config
	dobin config/nspr-config

	# Remove stupid files in /usr/bin
	rm "${ED}"/usr/bin/prerr.properties || die

	# This is used only to generate prerr.c and prerr.h at build time.
	# No other projects use it, and we don't want to depend on perl.
	# Talked to upstream and they agreed w/punting.
	rm "${ED}"/usr/bin/compile-et.pl || die
}
