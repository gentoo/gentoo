# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit autotools python-any-r1

DESCRIPTION="Advanced and well-established text-mode web browser"
HOMEPAGE="http://elinks.or.cz/"
SRC_URI="https://github.com/rkd77/felinks/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/felinks-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="bittorrent brotli bzip2 debug finger ftp gopher gnutls gpm guile idn ipv6
	javascript libressl lua +mouse nls nntp perl ruby samba ssl tre unicode X xml zlib"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	brotli? ( app-arch/brotli:= )
	bzip2? ( >=app-arch/bzip2-1.0.2 )
	gpm? ( >=sys-libs/ncurses-5.2:0= >=sys-libs/gpm-1.20.0-r5 )
	guile? ( >=dev-scheme/guile-1.6.4-r1[deprecated] )
	idn? ( net-dns/libidn:= )
	javascript? ( dev-lang/spidermonkey:17= )
	lua? ( >=dev-lang/lua-5:0= )
	perl? ( dev-lang/perl:= )
	ruby? ( dev-lang/ruby:* dev-ruby/rubygems:* )
	samba? ( net-fs/samba )
	ssl? (
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
		gnutls? ( net-libs/gnutls:= )
	)
	tre? ( dev-libs/tre )
	X? ( x11-libs/libX11 x11-libs/libXt )
	xml? ( >=dev-libs/expat-1.95.4 )
	zlib? ( >=sys-libs/zlib-1.1.4 )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${PN}-9999-parallel-make.patch
	"${FILESDIR}"/${P}-ruby-gcc10.patch
)

src_prepare() {
	default

	sed -i -e 's/-Werror//' configure* || die

	eautoreconf
}

src_configure() {
	local myconf=(
		--sysconfdir="${EPREFIX}"/etc/elinks
		--enable-leds
		--enable-88-colors
		--enable-256-colors
		--enable-true-color
		--enable-html-highlight
		$(use_with gpm)
		$(use_with brotli)
		$(use_with bzip2 bzlib)
		$(use_with guile)
		$(use_with idn)
		$(use_with javascript spidermonkey)
		--with-luapkg=$(usev lua)
		$(use_with perl)
		$(use_with ruby)
		$(use_with tre)
		$(use_with X x)
		$(use_with zlib)
		$(use_enable bittorrent)
		$(use_enable finger)
		$(use_enable ftp)
		$(use_enable gopher)
		$(use_enable ipv6)
		$(use_enable mouse)
		$(use_enable nls)
		$(use_enable nntp)
		$(use_enable samba smb)
		$(use_enable xml xbel)
	)

	if use debug ; then
		myconf+=( --enable-debug )
	else
		myconf+=( --enable-fastmem )
	fi

	if use ssl ; then
		if use gnutls ; then
			myconf+=( --with-gnutls )
		else
			myconf+=( --with-openssl="${EPREFIX}"/usr )
		fi
	else
		myconf+=( --without-openssl --without-gnutls )
	fi

	econf "${myconf[@]}"
}

src_compile() {
	emake V=1
}

src_install() {
	emake V=1 DESTDIR="${D}" install

	insinto /etc/elinks
	newins contrib/keybind-full.conf keybind-full.sample
	newins contrib/keybind.conf keybind.conf.sample

	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS README SITES THANKS TODO doc/*.*
	docinto contrib ; dodoc contrib/{README,colws.diff,elinks[-.]vim*}
	docinto contrib/lua ; dodoc contrib/lua/{*.lua,elinks-remote}
	docinto contrib/conv ; dodoc contrib/conv/*.*
	docinto contrib/guile ; dodoc contrib/guile/*.scm

	# elinks uses an internal copy of gettext which ships files that may
	# collide with the system's gettext (https://bugs.gentoo.org/635090)
	rm -f "${ED}"/usr/{share/locale/locale,lib/charset}.alias || die
}

pkg_postinst() {
	elog "You may want to convert your html.cfg and links.cfg of"
	elog "Links or older ELinks versions to the new ELinks elinks.conf"
	elog "using /usr/share/doc/${PF}/contrib/conv/conf-links2elinks.pl"
	elog
	elog "Please have a look at /etc/elinks/keybind-full.sample and"
	elog "/etc/elinks/keybind.conf.sample for some bindings examples."
	elog
	elog "You will have to set your TERM variable to 'xterm-256color'"
	elog "to be able to use 256 colors in elinks."
}
