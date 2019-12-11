# Copyright 1999-2019 Gentoo Authors
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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="berkdb debug doc examples gdbm ipv6 jemalloc jit libressl +rdoc rubytests socks5 +ssl static-libs tk xemacs"

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
	tk? (
		dev-lang/tcl:0=[threads]
		dev-lang/tk:0=[threads]
	)
	dev-libs/libyaml
	virtual/libffi:=
	sys-libs/readline:0=
	sys-libs/zlib
	>=app-eselect/eselect-ruby-20171225
"

DEPEND="${RDEPEND}"

BUNDLED_GEMS="
	>=dev-ruby/did_you_mean-1.2.1[ruby_targets_ruby26]
	>=dev-ruby/minitest-5.11.3[ruby_targets_ruby26]
	>=dev-ruby/net-telnet-0.2.0[ruby_targets_ruby26]
	>=dev-ruby/power_assert-1.1.3[ruby_targets_ruby26]
	>=dev-ruby/rake-12.3.2[ruby_targets_ruby26]
	>=dev-ruby/test-unit-3.2.9[ruby_targets_ruby26]
	>=dev-ruby/xmlrpc-0.3.0[ruby_targets_ruby26]
"

PDEPEND="
	${BUNDLED_GEMS}
	virtual/rubygems[ruby_targets_ruby26]
	>=dev-ruby/bundler-1.17.2[ruby_targets_ruby26]
	>=dev-ruby/json-2.0.2[ruby_targets_ruby26]
	rdoc? ( >=dev-ruby/rdoc-6.1.2[ruby_targets_ruby26] )
	xemacs? ( app-xemacs/ruby-modes )"

src_prepare() {
	# 005 does not compile bigdecimal and is questionable because it
	# compiles ruby in a non-standard way, may be dropped
	eapply "${FILESDIR}"/2.6/010*.patch

	einfo "Unbundling gems..."
	cd "$S"
	# Remove bundled gems that we will install via PDEPEND, bug
	# 539700.
	rm -fr gems/* || die

	einfo "Removing bundled libraries..."
	rm -fr ext/fiddle/libffi-3.2.1 || die

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
	# SuperH needs this
	use sh && append-flags -mieee

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
		--docdir=${EPREFIX}/usr/share/doc/${P} \
		--enable-shared \
		--enable-pthread \
		--disable-rpath \
		--with-out-ext="${modules}" \
		$(use_with jemalloc jemalloc) \
		$(use_enable jit jit-support ) \
		$(use_enable socks5 socks) \
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
	rm -rf ext/json || die
	rm -rf lib/bundler* lib/rdoc/rdoc.gemspec || die

	# Ruby is involved in the install process, we don't want interference here.
	unset RUBYOPT

	local MINIRUBY=$(echo -e 'include Makefile\ngetminiruby:\n\t@echo $(MINIRUBY)'|make -f - getminiruby)

	LD_LIBRARY_PATH="${S}:${ED}/usr/$(get_libdir)${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"
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
		insinto /usr/share/doc/${PF}
		doins -r sample
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
