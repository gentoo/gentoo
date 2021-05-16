# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

inherit apache-module flag-o-matic multilib ruby-ng toolchain-funcs

DESCRIPTION="Passenger makes deployment of Ruby on Rails applications a breeze"
HOMEPAGE="https://www.phusionpassenger.com/"
SRC_URI="https://s3.amazonaws.com/phusion-passenger/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="apache2 debug"

ruby_add_bdepend "dev-ruby/rake"

ruby_add_rdepend "
	>=dev-ruby/rack-1.0.0:*
	>=dev-ruby/rake-0.8.1"

# libev is bundled but with adapations that do not seem to be accepted
# upstream, so we must use the bundled version :-(
CDEPEND="
	>=dev-libs/libuv-1.8.0
	net-misc/curl[ssl]
	apache2? ( www-servers/apache[apache2_modules_unixd(+)] )"

RDEPEND="${RDEPEND} ${CDEPEND}"
DEPEND="${DEPEND} ${CDEPEND}"

APACHE2_MOD_CONF="30_mod_${PN}-5.0.0 30_mod_${PN}"
APACHE2_MOD_DEFINE="PASSENGER"

want_apache2

pkg_setup() {
	use debug && append-flags -DPASSENGER_DEBUG
	depend.apache_pkg_setup
}

all_ruby_prepare() {
	eapply "${FILESDIR}"/${PN}-5.1.11-gentoo.patch
	eapply "${FILESDIR}"/${PN}-5.1.1-isnan.patch

	# Change these with sed instead of a patch so that we can easily use
	# the toolchain-funcs methods.
	sed -i -e "/^CC/ s/=.*$/= '$(tc-getCC)'/" \
		-e "/^CXX\s/ s/=.*$/= '$(tc-getCXX)'/" \
		-e 's/PlatformInfo.debugging_cflags//' build/basics.rb || die

	# Avoid fixed debugging CFLAGs.
	sed -e '/debugging_cflags/areturn ""' -i src/ruby_supportlib/phusion_passenger/platform_info/compiler.rb || die

	# Use sed here so that we can dynamically set the documentation directory.
	sed -i -e "s:/usr/share/doc/passenger:/usr/share/doc/${P}:" \
		-e "s:/usr/lib/phusion-passenger/agents:/usr/libexec/phusion-passenger/agents:" \
		src/ruby_supportlib/phusion_passenger.rb || die
	sed -i -e "s:/usr/lib/phusion-passenger/agents:/usr/libexec/phusion-passenger/agents:" src/cxx_supportlib/ResourceLocator.h || die

	# Don't install a tool that won't work in our setup.
	sed -i -e '/passenger-install-apache2-module/d' src/ruby_supportlib/phusion_passenger/packaging.rb || die
	rm -f bin/passenger-install-apache2-module || die "Unable to remove unneeded install script."

	# Make sure we use the system-provided version where possible
	rm -rf src/cxx_supportlib/vendor-copy/libuv || die "Unable to remove vendored code."

	# Avoid building documentation to avoid a dependency on mizuho.
	#sed -i -e 's/, :doc//' build/packaging.rb || die
	touch doc/*.html || die

	# Fix hard-coded use of AR
	sed -i -e "s/ar cru/"$(tc-getAR)" cru/" build/support/cplusplus.rb || die

	# Make sure apache support is not attempted with -apache2
	if ! use apache2 ; then
		sed -i -e '/fakeroot/ s/:apache2, //' build/packaging.rb || die
	fi
}

all_ruby_compile() {
	if use apache2 ; then
		V=1 EXTRA_LDFLAGS="${LDFLAGS}" \
		 APXS2="${APXS}" \
		 HTTPD="${APACHE_BIN}" \
		 FS_LIBDIR='/usr/'$(get_libdir) \
		 USE_VENDORED_LIBUV="no" LIBUV_LIBS="-luv" \
		 RANLIB=$(tc-getRANLIB) \
		 ruby -S rake apache2 || die "rake failed"
	fi
}

each_ruby_compile() {
	append-flags -fno-strict-aliasing

	V=1 EXTRA_LDFLAGS="${LDFLAGS}" \
	APXS2="${APXS}" \
	HTTPD="${APACHE_BIN}" \
	FS_LIBDIR='/usr/'$(get_libdir) \
	USE_VENDORED_LIBUV="no" LIBUV_LIBS="-luv" \
	RANLIB=$(tc-getRANLIB) \
	${RUBY} -S rake native_support || die "rake failed"
}

all_ruby_install() {
	if use apache2 ; then
		APACHE2_MOD_FILE="${S}/buildout/apache2/mod_${PN}.so"
		apache-module_src_install

		# Patch in the correct libdir
		sed -i -e 's:/usr/lib/:/usr/'$(get_libdir)'/:' "${D}${APACHE_MODULES_CONFDIR}/30_mod_${PN}.conf" || die
	fi

	dodoc CHANGELOG README.md
}

each_ruby_install() {
	DISTDIR="${D}" \
	RUBYLIBDIR="$(ruby_rbconfig_value vendordir)" \
	RUBYARCHDIR="$(ruby_rbconfig_value archdir)" \
	APXS2="${APXS}" \
	HTTPD="${APACHE_BIN}" \
	FS_LIBDIR='/usr/'$(get_libdir) \
	EXTRA_LDFLAGS="${LDFLAGS}" \
	USE_VENDORED_LIBUV="no" LIBUV_LIBS="-luv" \
	RANLIB=$(tc-getRANLIB) \
	${RUBY} -S rake fakeroot || die "rake failed"
}
