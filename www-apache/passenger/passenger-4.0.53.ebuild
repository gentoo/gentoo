# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/passenger/passenger-4.0.53.ebuild,v 1.4 2015/04/19 10:16:50 ago Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit apache-module flag-o-matic multilib ruby-ng toolchain-funcs

DESCRIPTION="Passenger (a.k.a. mod_rails) makes deployment of Ruby on Rails applications a breeze"
HOMEPAGE="http://modrails.com/"
SRC_URI="http://s3.amazonaws.com/phusion-passenger/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

ruby_add_bdepend "dev-ruby/rake"

ruby_add_rdepend "
	>=dev-ruby/daemon_controller-1.2.0
	>=dev-ruby/rack-1.0.0
	>=dev-ruby/rake-0.8.1"

CDEPEND=">=dev-libs/libev-4.15 net-misc/curl[ssl]
	www-servers/apache[apache2_modules_unixd(+)]"

RDEPEND="${RDEPEND} ${CDEPEND}"
DEPEND="${DEPEND} ${CDEPEND}"

APACHE2_MOD_CONF="30_mod_${PN}-4.0.0 30_mod_${PN}"
APACHE2_MOD_DEFINE="PASSENGER"

need_apache2

pkg_setup() {
	use debug && append-flags -DPASSENGER_DEBUG
}

all_ruby_prepare() {
	epatch "${FILESDIR}"/${PN}-4.0.49-gentoo.patch

	# Change these with sed instead of a patch so that we can easily use
	# the toolchain-funcs methods.
	sed -i -e "s/gcc/$(tc-getCC)/" \
		-e "s/g++/$(tc-getCXX)/" \
		-e 's/PlatformInfo.debugging_cflags//' build/basics.rb || die

	# Avoid fixed debugging CFLAGs.
	sed -e '/debugging_cflags/areturn ""' -i lib/phusion_passenger/platform_info/compiler.rb || die

	# Use sed here so that we can dynamically set the documentation directory.
	sed -i -e "s:/usr/share/doc/passenger:/usr/share/doc/${P}:" \
		-e "s:/usr/lib/apache2/modules/mod_passenger.so:${APACHE_MODULESDIR}/mod_passenger.so:" \
		-e "s:/usr/lib/phusion-passenger/agents:/usr/libexec/phusion-passenger/agents:" \
		lib/phusion_passenger.rb || die
	sed -i -e "s:/usr/lib/phusion-passenger/agents:/usr/libexec/phusion-passenger/agents:" ext/common/ResourceLocator.h || die

	# Don't install a tool that won't work in our setup.
	sed -i -e '/passenger-install-apache2-module/d' lib/phusion_passenger/packaging.rb || die
	rm -f bin/passenger-install-apache2-module || die "Unable to remove unneeded install script."

	# Make sure we use the system-provided version.
	rm -rf ext/libev || die "Unable to remove vendored libev."

	# Avoid building documentation to avoid a dependency on mizuho.
	#sed -i -e 's/, :doc//' build/packaging.rb || die
	touch doc/*.html || die

	# Use the correct arch-specific lib directory
	sed -i -e 's:/usr/lib/:/usr/'$(get_libdir)'/:' build/packaging.rb || die

	# Fix hard-coded use of AR
	sed -i -e "s/ar cru/"$(tc-getAR)" cru/" build/cplusplus_support.rb || die
}

all_ruby_compile() {
	V=1 EXTRA_LDFLAGS="${LDFLAGS}" \
	APXS2="${APXS}" \
	HTTPD="${APACHE_BIN}" \
	USE_VENDORED_LIBEV="no" LIBEV_LIBS="-lev" \
	ruby -S rake apache2 || die "rake failed"
}

each_ruby_compile() {
	append-flags -fno-strict-aliasing

	V=1 EXTRA_LDFLAGS="${LDFLAGS}" \
	APXS2="${APXS}" \
	HTTPD="${APACHE_BIN}" \
	USE_VENDORED_LIBEV="no" LIBEV_LIBS="-lev" \
	${RUBY} -S rake native_support || die "rake failed"
}

all_ruby_install() {
	APACHE2_MOD_FILE="${S}/buildout/apache2/mod_${PN}.so"
	apache-module_src_install

	# Patch in the correct libdir
	sed -i -e 's:/usr/lib/:/usr/'$(get_libdir)'/:' "${D}${APACHE_MODULES_CONFDIR}/30_mod_${PN}.conf" || die
}

each_ruby_install() {
	DISTDIR="${D}" \
	RUBYLIBDIR="$(ruby_rbconfig_value vendordir)" \
	RUBYARCHDIR="$(ruby_rbconfig_value archdir)" \
	APXS2="${APXS}" \
	HTTPD="${APACHE_BIN}" \
	EXTRA_LDFLAGS="${LDFLAGS}" \
	USE_VENDORED_LIBEV="no" LIBEV_LIBS="-lev" \
	${RUBY} -S rake fakeroot || die "rake failed"
}

pkg_postint() {
	einfo "The apache module is compiled for the currently eselected ruby."
	einfo" If you eselect another ruby you must recompile passenger as well."
}
