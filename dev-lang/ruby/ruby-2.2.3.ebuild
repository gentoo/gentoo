# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#PATCHSET=1

inherit autotools eutils flag-o-matic multilib versionator

MY_P="${PN}-$(get_version_component_range 1-3)"
S=${WORKDIR}/${MY_P}

SLOT=$(get_version_component_range 1-2)
MY_SUFFIX=$(delete_version_separator 1 ${SLOT})
RUBYVERSION=2.2.0

if [[ -n ${PATCHSET} ]]; then
	if [[ ${PVR} == ${PV} ]]; then
		PATCHSET="${PV}-r0.${PATCHSET}"
	else
		PATCHSET="${PVR}.${PATCHSET}"
	fi
else
	PATCHSET="${PVR}"
fi

DESCRIPTION="An object-oriented scripting language"
HOMEPAGE="http://www.ruby-lang.org/"
SRC_URI="mirror://ruby/2.2/${MY_P}.tar.xz
		 http://dev.gentoo.org/~flameeyes/ruby-team/${PN}-patches-${PATCHSET}.tar.bz2"

LICENSE="|| ( Ruby-BSD BSD-2 )"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="berkdb debug doc examples gdbm ipv6 jemalloc +rdoc rubytests socks5 ssl xemacs ncurses +readline"

RDEPEND="
	berkdb? ( sys-libs/db:= )
	gdbm? ( sys-libs/gdbm )
	jemalloc? ( dev-libs/jemalloc )
	ssl? ( dev-libs/openssl:0 )
	socks5? ( >=net-proxy/dante-1.1.13 )
	ncurses? ( sys-libs/ncurses:5= )
	readline?  ( sys-libs/readline:0 )
	dev-libs/libyaml
	virtual/libffi
	sys-libs/zlib
	>=app-eselect/eselect-ruby-20141227
	!<dev-ruby/rdoc-3.9.4
	!<dev-ruby/rubygems-1.8.10-r1"

DEPEND="${RDEPEND}"

BUNDLED_GEMS="
	>=dev-ruby/minitest-5.4.3[ruby_targets_ruby22]
	>=dev-ruby/power_assert-0.2.2[ruby_targets_ruby22]
	>=dev-ruby/test-unit-3.0.8[ruby_targets_ruby22]
"

PDEPEND="
	${BUNDLED_GEMS}
	virtual/rubygems[ruby_targets_ruby22]
	>=dev-ruby/json-1.8.1[ruby_targets_ruby22]
	>=dev-ruby/rake-0.9.6[ruby_targets_ruby22]
	rdoc? ( >=dev-ruby/rdoc-4.0.1[ruby_targets_ruby22] )
	xemacs? ( app-xemacs/ruby-modes )"

src_prepare() {
	EPATCH_FORCE="yes" EPATCH_SUFFIX="patch" \
		epatch "${WORKDIR}/patches"

	# We can no longer unbundle all of rake because rubygems now depends
	# on this. We leave the actual rake code around to bootstrap
	# rubygems, but remove the bits that would cause a file collision.
	einfo "Unbundling gems..."
	cd "$S"
	rm -r \
		{bin,lib}/rake lib/rake.rb man/rake.1 \
		bin/gem || die "removal failed"
	# Remove bundled gems that we will install via PDEPEND, bug
	# 539700. Use explicit version numbers to ensure rm fails when they
	# change so we can update dependencies accordingly.
	rm gems/{minitest-5.4.3,power_assert-0.2.2,test-unit-3.0.8}.gem || die

	# Fix a hardcoded lib path in configure script
	sed -i -e "s:\(RUBY_LIB_PREFIX=\"\${prefix}/\)lib:\1$(get_libdir):" \
		configure.in || die "sed failed"

	eautoreconf
}

src_configure() {
	local myconf=

	# The Tk module can no longer be built because the module code is no
	# longer compatible with newer stable versions.
	# https://bugs.gentoo.org/show_bug.cgi?id=500894
	local modules="tk"

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
	if ! use readline ; then
		modules="${modules},readline"
	fi
	if ! use berkdb ; then
		modules="${modules},dbm"
	fi
	if ! use gdbm ; then
		modules="${modules},gdbm"
	fi
	if ! use ssl ; then
		modules="${modules},openssl"
	fi
	if ! use ncurses ; then
		modules="${modules},curses"
	fi

	INSTALL="${EPREFIX}/usr/bin/install -c" econf \
		--program-suffix=${MY_SUFFIX} \
		--with-soname=ruby${MY_SUFFIX} \
		--docdir=${EPREFIX}/usr/share/doc/${P} \
		--enable-shared \
		--enable-pthread \
		--disable-rpath \
		--with-out-ext="${modules}" \
		$(use_enable jemalloc jemalloc) \
		$(use_enable socks5 socks) \
		$(use_enable doc install-doc) \
		--enable-ipv6 \
		$(use_enable debug) \
		${myconf} \
		--enable-option-checking=no \
		|| die "econf failed"
}

src_compile() {
	emake V=1 EXTLDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_test() {
	emake -j1 V=1 test || die "make test failed"

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

	# Ruby is involved in the install process, we don't want interference here.
	unset RUBYOPT

	local MINIRUBY=$(echo -e 'include Makefile\ngetminiruby:\n\t@echo $(MINIRUBY)'|make -f - getminiruby)

	LD_LIBRARY_PATH="${D}/usr/$(get_libdir)${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"
	RUBYLIB="${S}:${D}/usr/$(get_libdir)/ruby/${RUBYVERSION}"
	for d in $(find "${S}/ext" -type d) ; do
		RUBYLIB="${RUBYLIB}:$d"
	done
	export LD_LIBRARY_PATH RUBYLIB

	emake V=1 DESTDIR="${D}" install || die "make install failed"

	# Remove installed rubygems copy
	rm -r "${D}/usr/$(get_libdir)/ruby/${RUBYVERSION}/rubygems" || die "rm rubygems failed"
	rm -r "${D}/usr/$(get_libdir)/ruby/${RUBYVERSION}"/rdoc* || die "rm rdoc failed"
	rm -r "${D}/usr/bin/"{ri,rdoc}"${MY_SUFFIX}" || die "rm rdoc bins failed"

	if use doc; then
		make DESTDIR="${D}" install-doc || die "make install-doc failed"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r sample
	fi

	dodoc ChangeLog NEWS doc/NEWS* README* || die

	if use rubytests; then
		pushd test
		insinto /usr/share/${PN}-${SLOT}/test
		doins -r .
		popd
	fi
}

pkg_postinst() {
	if [[ ! -n $(readlink "${ROOT}"usr/bin/ruby) ]] ; then
		eselect ruby set ruby${MY_SUFFIX}
	fi

	elog
	elog "To switch between available Ruby profiles, execute as root:"
	elog "\teselect ruby set ruby(19|20|...)"
	elog
}

pkg_postrm() {
	eselect ruby cleanup
}
