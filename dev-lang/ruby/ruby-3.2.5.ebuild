# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multiprocessing

MY_P="${PN}-$(ver_cut 1-3)"
S=${WORKDIR}/${MY_P}

SLOT=$(ver_cut 1-2)
MY_SUFFIX=$(ver_rs 1 '' ${SLOT})
RUBYVERSION=${SLOT}.0

DESCRIPTION="An object-oriented scripting language"
HOMEPAGE="https://www.ruby-lang.org/"
SRC_URI="https://cache.ruby-lang.org/pub/ruby/${SLOT}/${MY_P}.tar.xz"

LICENSE="|| ( Ruby-BSD BSD-2 )"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="berkdb debug doc examples gdbm ipv6 jemalloc jit socks5 +ssl static-libs systemtap tk valgrind xemacs"

RDEPEND="
	berkdb? ( sys-libs/db:= )
	gdbm? ( sys-libs/gdbm:= )
	jemalloc? ( dev-libs/jemalloc:= )
	jit? ( >=virtual/rust-1.58.1 )
	ssl? (
		dev-libs/openssl:0=
	)
	socks5? ( >=net-proxy/dante-1.1.13 )
	systemtap? ( dev-debug/systemtap )
	tk? (
		dev-lang/tcl:0=[threads]
		dev-lang/tk:0=[threads]
	)
	dev-libs/libyaml
	dev-libs/libffi:=
	sys-libs/readline:0=
	sys-libs/zlib
	virtual/libcrypt:=
	>=app-eselect/eselect-ruby-20231008
"

DEPEND="
	${RDEPEND}
	valgrind? ( dev-debug/valgrind )
"

BUNDLED_GEMS="
	>=dev-ruby/debug-1.7.1[ruby_targets_ruby32(-)]
	>=dev-ruby/irb-1.6.2[ruby_targets_ruby32(-)]
	>=dev-ruby/matrix-0.4.2[ruby_targets_ruby32(-)]
	>=dev-ruby/minitest-5.16.3[ruby_targets_ruby32(-)]
	>=dev-ruby/net-ftp-0.2.0[ruby_targets_ruby32(-)]
	>=dev-ruby/net-imap-0.3.4[ruby_targets_ruby32(-)]
	>=dev-ruby/net-pop-0.1.2[ruby_targets_ruby32(-)]
	>=dev-ruby/net-smtp-0.3.3[ruby_targets_ruby32(-)]
	>=dev-ruby/power_assert-2.0.3[ruby_targets_ruby32(-)]
	>=dev-ruby/prime-0.1.2[ruby_targets_ruby32(-)]
	>=dev-ruby/rake-13.0.6-r2[ruby_targets_ruby32(-)]
	>=dev-ruby/rbs-2.8.2[ruby_targets_ruby32(-)]
	>=dev-ruby/rexml-3.2.5[ruby_targets_ruby32(-)]
	>=dev-ruby/rss-0.2.9[ruby_targets_ruby32(-)]
	>=dev-ruby/test-unit-3.5.7[ruby_targets_ruby32(-)]
	>=dev-ruby/typeprof-0.21.3[ruby_targets_ruby32(-)]
"

PDEPEND="
	${BUNDLED_GEMS}
	virtual/rubygems[ruby_targets_ruby32(-)]
	>=dev-ruby/bundler-2.3.3[ruby_targets_ruby32(-)]
	>=dev-ruby/did_you_mean-1.6.1[ruby_targets_ruby32(-)]
	>=dev-ruby/json-2.6.1[ruby_targets_ruby32(-)]
	>=dev-ruby/rdoc-6.3.3[ruby_targets_ruby32(-)]
	xemacs? ( app-xemacs/ruby-modes )
"

src_prepare() {
	eapply "${FILESDIR}"/"${SLOT}"/010*.patch
	eapply "${FILESDIR}"/"${SLOT}"/011*.patch
	eapply "${FILESDIR}"/"${SLOT}"/013*.patch
	eapply "${FILESDIR}"/"${SLOT}"/902*.patch

	if use elibc_musl ; then
		eapply "${FILESDIR}"/${SLOT}/901-musl-*.patch
	fi

	einfo "Unbundling gems..."
	cd "$S"
	# Remove bundled gems that we will install via PDEPEND, bug
	# 539700.
	rm -fr gems/* || die
	touch gems/bundled_gems || die
	# Don't install CLI tools since they will clash with the gem
	rm -f bin/{racc,racc2y,y2racc} || die
	sed -i -e '/executables/ s:^:#:' lib/racc/racc.gemspec || die

	# Remove tests that are known to fail or require a network connection
	rm -f test/ruby/test_process.rb test/rubygems/test_gem{,_path_support}.rb || die
	rm -f test/rinda/test_rinda.rb test/socket/test_tcp.rb test/fiber/test_address_resolve.rb spec/ruby/library/socket/tcpsocket/{initialize,open}_spec.rb|| die

	# Remove webrick tests because setting LD_LIBRARY_PATH does not work for them.
	rm -rf tool/test/webrick || die

	# Avoid test using the system ruby
	sed -i -e '/test_dumb_terminal/aomit "Uses system ruby"' test/reline/test_reline.rb || die

	# Avoid testing against hard-coded blockdev devices that most likely are not available
	sed -i -e '/def blockdev/a@blockdev = nil' test/ruby/test_file_exhaustive.rb || die

	# Avoid tests that require gem downloads
	sed -i -e '/^test-syntax-suggest/ s/\$(TEST_RUNNABLE)/no/' common.mk || die
	sed -i -e '/^check:/ s/\$(TEST_RUNNABLE)-\$(PREPARE_SYNTAX_SUGGEST) test-syntax-suggest//' common.mk || die

	# Avoid test that fails intermittently
	sed -i -e '/test_gem_exec_gem_uninstall/aomit "Fails intermittently"' test/rubygems/test_gem_commands_exec_command.rb || die

	if use prefix ; then
		# Fix hardcoded SHELL var in mkmf library
		sed -i -e "s#\(SHELL = \).*#\1${EPREFIX}/bin/sh#" lib/mkmf.rb || die
	fi

	eapply_user

	eautoreconf
}

src_configure() {
	local modules="win32,win32ole" myconf=

	# Ruby's build system does interesting things with MAKEOPTS and doesn't
	# handle MAKEOPTS="-Oline" or similar well. Just filter it all out
	# and use -j/-l parsed out from the original MAKEOPTS, then use that.
	# Newer Portage sets this option by default in GNUMAKEFLAGS if nothing
	# is set by the user in MAKEOPTS. See bug #900929 and bug #728424.
	local makeopts_tmp="-j$(makeopts_jobs) -l$(makeopts_loadavg)"
	unset MAKEOPTS MAKEFLAGS GNUMAKEFLAGS
	export MAKEOPTS="${makeopts_tmp}"

	# Avoid a hardcoded path to mkdir to avoid issues with mixed
	# usr-merge and normal binary packages, bug #932386.
	export ac_cv_path_mkdir=mkdir

	# -fomit-frame-pointer makes ruby segfault, see bug #150413.
	filter-flags -fomit-frame-pointer
	# In many places aliasing rules are broken; play it safe
	# as it's risky with newer compilers to leave it as it is.
	append-flags -fno-strict-aliasing

	# Workaround for bug #938302
	if use systemtap && has_version "dev-debug/systemtap[-dtrace-symlink(+)]" ; then
		export DTRACE="${BROOT}"/usr/bin/stap-dtrace
	fi

	# Socks support via dante
	if use socks5 ; then
		# Socks support can't be disabled as long as SOCKS_SERVER is
		# set and socks library is present, so need to unset
		# SOCKS_SERVER in that case.
		unset SOCKS_SERVER
	fi

	# Increase GC_MALLOC_LIMIT if set (default is 8000000)
	if [ -n "${RUBY_GC_MALLOC_LIMIT}" ] ; then
		append-flags "-DGC_MALLOC_LIMIT=${RUBY_GC_MALLOC_LIMIT}"
	fi

	# ipv6 hack, bug 168939. Needs --enable-ipv6.
	use ipv6 || myconf="${myconf} --with-lookup-order-hack=INET"

	# Determine which modules *not* to build depending in the USE flags.
	if ! use berkdb ; then
		modules="${modules},dbm"
	fi
	if ! use gdbm ; then
		modules="${modules},gdbm"
	fi
	if ! use ssl ; then
		modules="${modules},openssl"
	fi
	if ! use tk ; then
		modules="${modules},tk"
	fi

	# Provide an empty LIBPATHENV because we disable rpath but we do not
	# need LD_LIBRARY_PATH by default since that breaks USE=multitarget
	# #564272
	# except on Darwin, where we really need LIBPATHENV to set the right
	# DYLD_ stuff during the invocation of miniruby for it to work
	[[ ${CHOST} == *-darwin* ]] || export LIBPATHENV=""
	INSTALL="${EPREFIX}/usr/bin/install -c" econf \
		--program-suffix=${MY_SUFFIX} \
		--with-soname=ruby${MY_SUFFIX} \
		--with-readline-dir="${EPREFIX}"/usr \
		--enable-shared \
		--enable-pthread \
		--disable-rpath \
		--without-baseruby \
		--with-compress-debug-sections=no \
		--enable-mkmf-verbose \
		--with-out-ext="${modules}" \
		$(use_with jemalloc jemalloc) \
		$(use_enable jit jit-support) \
		$(use_enable jit yjit) \
		$(use_enable socks5 socks) \
		$(use_enable systemtap dtrace) \
		$(use_enable doc install-doc) \
		--enable-ipv6 \
		$(use_enable static-libs static) \
		$(use_enable static-libs install-static-library) \
		$(use_with static-libs static-linked-ext) \
		$(use_enable debug) \
		${myconf} \
		$(use_with valgrind) \
		--enable-option-checking=no

	# Makefile is broken because it lacks -ldl
	rm -rf ext/-test-/popen_deadlock || die
}

src_compile() {
	local -x LD_LIBRARY_PATH="${S}${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"
	emake V=1 EXTLDFLAGS="${LDFLAGS}" MJIT_CFLAGS="${CFLAGS}" MJIT_OPTFLAGS="" MJIT_DEBUGFLAGS=""
}

src_test() {
	local -x LD_LIBRARY_PATH="${S}${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"
	emake V=1 check
}

src_install() {
	# Remove the remaining bundled gems. We do this late in the process
	# since they are used during the build to e.g. create the
	# documentation.
	einfo "Removing default gems before installation"
	rm -rf lib/bundler* lib/rdoc/rdoc.gemspec || die

	# Ruby is involved in the install process, we don't want interference here.
	unset RUBYOPT

	local MINIRUBY=$(echo -e 'include Makefile\ngetminiruby:\n\t@echo $(MINIRUBY)'|make -f - getminiruby)

	local -x LD_LIBRARY_PATH="${S}:${ED}/usr/$(get_libdir)${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"

	local -x RUBYLIB="${S}:${ED}/usr/$(get_libdir)/ruby/${RUBYVERSION}"
	for d in $(find "${S}/ext" -type d) ; do
		RUBYLIB="${RUBYLIB}:$d"
	done

	# Create directory for the default gems
	local gem_home="${EPREFIX}/usr/$(get_libdir)/ruby/gems/${RUBYVERSION}"
	mkdir -p "${D}/${gem_home}" || die "mkdir gem home failed"

	emake V=1 DESTDIR="${D}" GEM_DESTDIR=${gem_home} install

	# Remove installed rubygems and rdoc copy
	rm -rf "${ED}/usr/$(get_libdir)/ruby/${RUBYVERSION}/rubygems" || die "rm rubygems failed"
	rm -rf "${ED}/usr/bin/"gem"${MY_SUFFIX}" || die "rm rdoc bins failed"
	rm -rf "${ED}/usr/$(get_libdir)/ruby/${RUBYVERSION}"/rdoc* || die "rm rdoc failed"
	rm -rf "${ED}/usr/bin/"{bundle,bundler,ri,rdoc}"${MY_SUFFIX}" || die "rm rdoc bins failed"

	if use doc; then
		emake DESTDIR="${D}" GEM_DESTDIR=${gem_home} install-doc
	fi

	if use examples; then
		dodoc -r sample
	fi

	dodoc ChangeLog NEWS.md README*
	dodoc -r doc
}

pkg_postinst() {
	if [[ ! -n $(readlink "${EROOT}"/usr/bin/ruby) ]] ; then
		eselect ruby set ruby${MY_SUFFIX}
	fi

	elog
	elog "To switch between available Ruby profiles, execute as root:"
	elog "\teselect ruby set ruby(30|31|...)"
	elog
}

pkg_postrm() {
	eselect ruby cleanup
}
