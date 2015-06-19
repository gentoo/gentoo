# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/rubinius/rubinius-1.2.4.20110705.ebuild,v 1.7 2014/03/23 07:07:45 graaff Exp $

EAPI=4
inherit eutils flag-o-matic multilib versionator

DESCRIPTION="A re-implementation of the Ruby VM designed for speed"
HOMEPAGE="http://rubini.us"
MY_PV=$(replace_version_separator 3 -)
SRC_URI="http://asset.rubini.us/${PN}-${MY_PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+llvm"

S=${WORKDIR}/${PN}-$(get_version_component_range 1-3)

RDEPEND="sys-libs/readline
	llvm? ( >=sys-devel/llvm-2.8 <sys-devel/llvm-3 )
	dev-libs/openssl
	sys-libs/zlib"
DEPEND="${RDEPEND}
	sys-devel/bison
	dev-lang/ruby:1.9
	dev-ruby/rake"

pkg_setup() {
	unset RUBYOPT
}

src_prepare() {
	# Drop error CFLAGS per Gentoo policy.
	sed -i -e '/Werror/ s:^:#:' rakelib/blueprint.rb || die

	sed -i -e 's/-ggdb3//' vm/test/one.sh vm/external_libs/libtommath/makefile vm/external_libs/libgdtoa/Makefile rakelib/ext_helper.rb lib/rbconfig.rb lib/ext/melbourne/extconf.rb || die
}

src_configure() {
	#Rubinius uses a non-autoconf ./configure script which balks at econf
	./configure --skip-prebuilt \
		--prefix /usr/$(get_libdir) \
		--mandir /usr/share/man \
		$(use_enable llvm) \
		|| die "Configure failed"
}

src_compile() {
	rake build || die "Rake failed"
}

src_test() {
	if [ $UID != 0 ] ; then
		rake vm:test || die
		# These currently cause a weird and uninformative "Hangup".
#		RBX_RUNTIME="${S}/runtime" RBX_LIB="${S}/lib" bin/mspec ci --background --agent || die
	else
		ewarn "Tests will fail if run as root.  Set FEATURES=userpriv if " \
			"you want to run tests."
	fi
}

src_install() {
	local minor_version=$(get_version_component_range 1-2)
	local librbx="usr/$(get_libdir)/rubinius"

	einfo "install:build"
	rake compiler:load install:build || die "rake install:build failed"

	einfo "install:files"
	FAKEROOT="${D}" rake install:files || die "rake install:files failed"

	dosym /${librbx}/${minor_version}/bin/rbx /usr/bin/rbx || die "Couldn't make rbx symlink"

	insinto /${librbx}/${minor_version}/site
	doins "${FILESDIR}/auto_gem.rb" || die "Couldn't install rbx auto_gem.rb"
	RBX_RUNTIME="${S}/runtime" RBX_LIB="${S}/lib" bin/rbx compile "${D}/${librbx}/${minor_version}/site/auto_gem.rb" || die "Couldn't bytecompile auto_gem.rb"
}
