# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib

MY_P="${PN}-$(ver_cut 1-3)"
S=${WORKDIR}/${MY_P}

SLOT=$(ver_cut 1-2)
MY_SUFFIX=$(ver_rs 1 '' ${SLOT})
RUBYVERSION=${SLOT}.0

DESCRIPTION="An object-oriented scripting language"
HOMEPAGE="https://www.ruby-lang.org/"
SRC_URI="https://cache.ruby-lang.org/pub/ruby/${SLOT}/${MY_P}.tar.xz"

LICENSE="|| ( Ruby-BSD BSD-2 )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="berkdb debug doc examples gdbm ipv6 jemalloc jit libressl +rdoc rubytests socks5 +ssl static-libs systemtap tk xemacs"

RDEPEND="
	berkdb? ( sys-libs/db:= )
	gdbm? ( sys-libs/gdbm:= )
	jemalloc? ( dev-libs/jemalloc )
	jit? ( || ( sys-devel/gcc:* sys-devel/clang:* ) )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl )
	)
	socks5? ( >=net-proxy/dante-1.1.13 )
	systemtap? ( dev-util/systemtap )
	tk? (
		dev-lang/tcl:0=[threads]
		dev-lang/tk:0=[threads]
	)
	dev-libs/libyaml
	dev-libs/libffi:=
	sys-libs/readline:0=
	sys-libs/zlib
	>=app-eselect/eselect-ruby-20191222
"

DEPEND="${RDEPEND}"

BUNDLED_GEMS="
	>=dev-ruby/minitest-5.13.0[ruby_targets_ruby27]
	>=dev-ruby/net-telnet-0.2.0[ruby_targets_ruby27]
	>=dev-ruby/power_assert-1.1.7[ruby_targets_ruby27]
	>=dev-ruby/rake-13.0.1[ruby_targets_ruby27]
	>=dev-ruby/test-unit-3.3.4[ruby_targets_ruby27]
	>=dev-ruby/xmlrpc-0.3.0[ruby_targets_ruby27]
"

PDEPEND="
	${BUNDLED_GEMS}
	virtual/rubygems[ruby_targets_ruby27]
	>=dev-ruby/bundler-2.1.4[ruby_targets_ruby27]
	>=dev-ruby/did_you_mean-1.3.1[ruby_targets_ruby27]
	>=dev-ruby/json-2.0.2[ruby_targets_ruby27]
	rdoc? ( >=dev-ruby/rdoc-6.1.2[ruby_targets_ruby27] )
	xemacs? ( app-xemacs/ruby-modes )"

src_prepare() {
	# 005 does not compile bigdecimal and is questionable because it
	# compiles ruby in a non-standard way, may be dropped
	eapply "${FILESDIR}"/2.7/{002,010}*.patch

	einfo "Unbundling gems..."
	cd "$S"
	# Remove bundled gems that we will install via PDEPEND, bug
	# 539700.
	rm -fr gems/* || die
	# Don't install CLI tools since they will clash with the gem
	rm -f bin/{racc,racc2y,y2racc} || die
	sed -i -e '/executables/ s:^:#:' lib/racc/racc.gemspec || die

	einfo "Removing bundled libraries..."
	rm -fr ext/fiddle/libffi-3.2.1 || die

	if use prefix ; then
		# Fix hardcoded SHELL var in mkmf library
		sed -i -e "s#\(SHELL = \).*#\1${EPREFIX}/bin/sh#" lib/mkmf.rb || die

		if [[ ${CHOST} == *darwin* ]] ; then
			# avoid symlink loop on Darwin (?!)
			sed -i \
				-e '/LIBRUBY_ALIASES=/s/lib$(RUBY_INSTALL_NAME).$(SOEXT)//' \
				configure.ac || die

			# make ar/libtool hack for Darwin work
			sed -i \
				-e "s/ac_cv_prog_ac_ct_AR='libtool/ac_cv_prog_AR='${CHOST}-libtool/" \
				configure.ac || die
		fi
	fi

	eapply_user

	eautoreconf
}

src_configure() {
	local modules= myconf=

	# -fomit-frame-pointer makes ruby segfault, see bug #150413.
	filter-flags -fomit-frame-pointer
	# In many places aliasing rules are broken; play it safe
	# as it's risky with newer compilers to leave it as it is.
	append-flags -fno-strict-aliasing

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
	INSTALL="${EPREFIX}/usr/bin/install -c" LIBPATHENV="" econf \
		--program-suffix=${MY_SUFFIX} \
		--with-soname=ruby${MY_SUFFIX} \
		--with-readline-dir="${EPREFIX}"/usr \
		--enable-shared \
		--enable-pthread \
		--disable-rpath \
		--with-out-ext="${modules}" \
		$(use_with jemalloc jemalloc) \
		$(use_enable jit jit-support ) \
		$(use_enable socks5 socks) \
		$(use_enable systemtap dtrace) \
		$(use_enable doc install-doc) \
		--enable-ipv6 \
		$(use_enable static-libs static) \
		$(use_enable static-libs install-static-library) \
		$(use_with static-libs static-linked-ext) \
		$(use_enable debug) \
		${myconf} \
		--enable-option-checking=no

	# Makefile is broken because it lacks -ldl
	rm -rf ext/-test-/popen_deadlock || die
}

src_compile() {
	emake V=1 EXTLDFLAGS="${LDFLAGS}" MJIT_CFLAGS="${CFLAGS}" MJIT_OPTFLAGS="" MJIT_DEBUGFLAGS=""
}

src_test() {
	emake -j1 V=1 test

	elog "Ruby's make test has been run. Ruby also ships with a make check"
	elog "that cannot be run until after ruby has been installed."
	elog
	if use rubytests; then
		elog "You have enabled rubytests, so they will be installed to"
		elog "/usr/share/${PN}-${SLOT}/test. To run them you must be a user other"
		elog "than root, and you must place them into a writeable directory."
		elog "Then call: "
		elog
		elog "ruby${MY_SUFFIX} -C /location/of/tests runner.rb"
	else
		elog "Enable the rubytests USE flag to install the make check tests"
	fi
}

src_install() {
	# Remove the remaining bundled gems. We do this late in the process
	# since they are used during the build to e.g. create the
	# documentation.
	einfo "Removing default gems before installation"
	rm -rf .ext/common/json.rb .ext/common/json ext/json || die
	rm -rf lib/bundler* lib/rdoc/rdoc.gemspec || die
	rm -rf lib/did_you_mean* || die

	# Ruby is involved in the install process, we don't want interference here.
	unset RUBYOPT

	local MINIRUBY=$(echo -e 'include Makefile\ngetminiruby:\n\t@echo $(MINIRUBY)'|make -f - getminiruby)

	LD_LIBRARY_PATH="${S}:${ED}/usr/$(get_libdir)${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"

	if [[ ${CHOST} == *darwin* ]] ; then
		DYLD_LIBRARY_PATH="${S}:${ED}/usr/$(get_libdir)${DYLD_LIBRARY_PATH+:}${DYLD_LIBRARY_PATH}"
		export DYLD_LIBRARY_PATH
	fi

	RUBYLIB="${S}:${ED}/usr/$(get_libdir)/ruby/${RUBYVERSION}"
	for d in $(find "${S}/ext" -type d) ; do
		RUBYLIB="${RUBYLIB}:$d"
	done
	export LD_LIBRARY_PATH RUBYLIB

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

	dodoc ChangeLog NEWS doc/NEWS* README*

	if use rubytests; then
		pushd test
		insinto /usr/share/${PN}-${SLOT}/test
		doins -r .
		popd
	fi
}

pkg_postinst() {
	if [[ ! -n $(readlink "${EROOT}"/usr/bin/ruby) ]] ; then
		eselect ruby set ruby${MY_SUFFIX}
	fi

	elog
	elog "To switch between available Ruby profiles, execute as root:"
	elog "\teselect ruby set ruby(23|24|...)"
	elog
}

pkg_postrm() {
	eselect ruby cleanup
}
