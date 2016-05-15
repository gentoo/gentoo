# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic multilib versionator

DESCRIPTION="A re-implementation of the Ruby VM designed for speed"
HOMEPAGE="http://rubini.us"
SRC_URI="http://releases.rubini.us/${P}.tar.bz2"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+llvm"

RDEPEND="
	llvm? ( <sys-devel/llvm-3.6
		>=sys-devel/llvm-3.2 )
	dev-libs/openssl:0
	sys-libs/ncurses
	sys-libs/readline:0
	dev-libs/libyaml
	virtual/libffi
	sys-libs/zlib
"

DEPEND="${RDEPEND}
	=dev-ruby/rake-10*
	dev-ruby/bundler
"

pkg_setup() {
	unset RUBYOPT
}

src_prepare() {
	# src_test will wait until all processes are reaped, so tune down
	# the long sleep process a bit.
	sed -i -e 's/sleep 1000/sleep 300/' spec/ruby/core/io/popen_spec.rb || die

	# Drop error CFLAGS per Gentoo policy.
	sed -i -e '/Werror/ s:^:#:' rakelib/blueprint.rb || die

	bundle --local || die
}

src_configure() {
	conf=""
	if ! use llvm ; then
		conf+="--disable-llvm "
	fi

	#Rubinius uses a non-autoconf ./configure script which balks at econf
	INSTALL="${EPREFIX}/usr/bin/install -c" ./configure \
		--prefix /usr/$(get_libdir) \
		--mandir /usr/share/man \
		--without-rpath \
		--with-vendor-zlib \
		${conf} \
		|| die "Configure failed"
}

src_compile() {
	RBXOPT="-Xsystem.log=/dev/null" rake build || die "Compilation failed"
}

src_test() {
	rake spec || die "Tests failed"
	einfo "Waiting for forked processes to die"
}

src_install() {
	# The install phase tries to determine if there are relevant
	addpredict /usr/local/lib64/ruby

	local minor_version=$(get_version_component_range 1-2)
	local librbx="usr/$(get_libdir)/rubinius"

	RBXOPT="-Xsystem.log=/dev/null" DESTDIR="${D}" rake install || die "Installation failed"

	dosym /${librbx}/bin/rbx /usr/bin/rbx || die "Couldn't make rbx symlink"

	insinto /${librbx}/${minor_version}/site
	doins "${FILESDIR}/auto_gem.rb" || die "Couldn't install rbx auto_gem.rb"
	RBXOPT="-Xsystem.log=/dev/null" RBX_RUNTIME="${S}/runtime" RBX_LIB="${S}/lib" bin/rbx compile "${D}/${librbx}/${minor_version}/site/auto_gem.rb" || die "Couldn't bytecompile auto_gem.rb"
}
