# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/pavuk/pavuk-0.9.36_pre20120215-r2.ebuild,v 1.2 2013/02/04 18:44:47 pacho Exp $

EAPI=5

S="${WORKDIR}/${PN}"
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils autotools-utils

DESCRIPTION="Web spider and website mirroring tool"
HOMEPAGE="http://www.pavuk.org/"
SRC_URI="http://dev.gentoo.org/~pacho/maintainer-needed/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug gtk hammer ipv6 nls pcre profile ssl"

RDEPEND="virtual/libintl:=
	gtk? ( x11-libs/gtk+:2 )
	pcre? ( dev-libs/libpcre:= )
	ssl? ( dev-libs/openssl:= )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	sys-devel/gettext"

PATCHES=(
	# Fixes a bug in re.c for PCRE support
	"${FILESDIR}/${P}-pcre-fix.patch"

	# Fixes underlinking, bug #405337
	"${FILESDIR}/${P}-fix-underlinking.patch"

	# Fixes a segfault in the GTK+2 interface on amd64, bug #262504#c40
	"${FILESDIR}/${P}-fix-gtkmulticol-segfault.patch"

	# Fixed overflow, bug #450990
	"${FILESDIR}/${P}-tl_selectr-overflow-fix.patch"
)

DOCS=( README CREDITS NEWS AUTHORS BUGS TODO MAILINGLIST wget-pavuk.HOWTO
		ChangeLog wget-pavuk.HOWTO pavuk_authinfo.sample pavukrc.sample	)

src_prepare() {
	# Fixes a bug in Makefile.am that causes aclocal to fail
	sed -i 's/^\(ACLOCAL_AMFLAGS[[:space:]]*=[[:space:]]*-I[[:space:]]*\)\$(top_srcdir)\//\1/' "${S}/Makefile.am" || die

	# Fixes a bug in configure.in that breaks non-debug builds
	sed -i 's/\([[:space:]]C\(PP\)*FLAGS=`\)/true; # \1/' "${S}/configure.in" || die

	# Fix for building with ~dev-lang/spidermonkey-1.8.5
	# sed -i 's/mozjs/mozjs185/g' "${S}/configure.in" || die

	autotools-utils_src_prepare
}

src_configure() {
	local regex="auto"
	use pcre && regex="pcre"

	local myeconfargs=(
			--enable-threads
			--enable-socks
			--enable-utf-8
			--disable-js
			"--with-regex=${regex}"
			$(use_enable gtk)
			$(use_enable gtk gtk2)
			$(use_enable gtk gnome)
			$(use_with gtk x)
			$(use_enable debug debugging)
			$(use_enable debug debug-build)
			# $(use_enable debug debug-features)
			$(use_enable ssl)
			$(use_enable nls)
			$(use_enable ipv6)
			# $(use_enable javascript js)
			$(use_enable profile profiling)
	)

	# JavaScript bindings: Broken!
	# ============================
	# Currently could pass configure phase with ~dev-lang/spidermonkey-1.8.5
	# yet apparently incompatible with recent versions of spidermonkey

	# if use javascript; then
	# 	local jspkg='mozjs185'
	# 	local jsinclude=$(pkg-config --cflags "$jspkg")
	# 	local jslibs='/dev/null '$(pkg-config --libs-only-l "$jspkg")
	# 	myeconfargs+=(
	# 			"--with-js-include=${jsinclude}"
	# 			"--with-js-libraries=${jslibs}"
	# 			)
	# fi

	autotools-utils_src_configure
}

src_install() {
	if use gtk; then
		newicon src/pavuk_logo.xpm pavuk.xpm
		domenu pavuk.desktop
	fi

	doman "${S}/doc/pavuk.1"

	autotools-utils_src_install
}
