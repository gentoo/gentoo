# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs multilib-minimal

MIN_PV="$(ver_cut 2)"

DESCRIPTION="Netscape Portable Runtime"
HOMEPAGE="https://www.mozilla.org/projects/nspr/"
SRC_URI="https://archive.mozilla.org/pub/nspr/releases/v${PV}/src/${P}.tar.gz"

LICENSE="|| ( MPL-2.0 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="debug"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/nspr-config
)

PATCHES=(
	"${FILESDIR}"/${PN}-4.7.1-solaris.patch
	"${FILESDIR}"/${PN}-4.8.4-darwin-install_name.patch
	"${FILESDIR}"/${PN}-4.8.9-link-flags.patch
	# We do not need to pass -L$libdir via nspr-config --libs
	"${FILESDIR}"/${PN}-4.9.5_nspr_config.patch
)

QA_CONFIGURE_OPTIONS="--disable-static"

src_prepare() {
	cd "${S}"/nspr || die

	default

	if use elibc_musl; then
		eapply "${FILESDIR}"/${PN}-4.21-ipv6-musl-support.patch
		eapply "${FILESDIR}"/nspr-4.35-bgo-905998-lfs64-musl.patch
	fi

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
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/867634
	#
	# Testsuite-only issue. Still, this makes it challenging to test the package with LTO
	# enabled...
	append-flags -fno-strict-aliasing
	filter-lto

	# The build system overrides user optimization level based on a configure flag. #886987
	local my_optlvl=$(get-flag '-O*')

	# bgo #923802
	append-lfs-flags

	# We use the standard BUILD_xxx but nspr uses HOST_xxx
	tc-export_build_env BUILD_CC
	export HOST_CC=${BUILD_CC} HOST_CFLAGS=${BUILD_CFLAGS} HOST_LDFLAGS=${BUILD_LDFLAGS}
	tc-export AR AS CC CXX RANLIB
	[[ ${CBUILD} != ${CHOST} ]] \
		&& export CROSS_COMPILE=1 \
		|| unset CROSS_COMPILE

	local myconf=( --libdir="${EPREFIX}/usr/$(get_libdir)" )

	# Optimization is disabled when debug is enabled.
	if use debug; then
		myconf+=( --enable-debug )
	else
		myconf+=( --disable-debug )
		myconf+=( --enable-optimize="${my_optlvl}" )
	fi

	# The configure has some fancy --enable-{{n,x}32,64bit} switches
	# that trigger some code conditional to platform & arch. This really
	# matters for the few common arches (x86, ppc) but we pass a little
	# more of them to be future-proof.
	case $(tc-get-ptr-size) in
		4) use abi_x86_x32 && myconf+=( --enable-x32 );;
		8) myconf+=( --enable-64bit );;
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
