# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"
inherit autotools git-r3 python-any-r1

EGIT_REPO_URI="https://github.com/rkd77/felinks"

MY_P="${P/_/}"
DESCRIPTION="Advanced and well-established text-mode web browser"
HOMEPAGE="http://elinks.or.cz/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="bittorrent brotli bzip2 debug finger ftp gopher gpm guile idn ipv6
	  javascript libressl lua +mouse nls nntp perl ruby samba ssl tre unicode X xml zlib"
RESTRICT="test"

DEPEND="
	${PYTHON_DEPS}
	brotli? ( app-arch/brotli )
	bzip2? ( >=app-arch/bzip2-1.0.2 )
	gpm? ( >=sys-libs/ncurses-5.2:0= >=sys-libs/gpm-1.20.0-r5 )
	guile? ( >=dev-scheme/guile-1.6.4-r1[deprecated,discouraged] )
	idn? ( net-dns/libidn )
	javascript? ( >=dev-lang/spidermonkey-1.8.5:0= )
	lua? ( >=dev-lang/lua-5:0= )
	perl? ( dev-lang/perl:= )
	ruby? ( dev-lang/ruby:* dev-ruby/rubygems:* )
	samba? ( net-fs/samba )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	tre? ( dev-libs/tre )
	X? ( x11-libs/libX11 x11-libs/libXt )
	xml? ( >=dev-libs/expat-1.95.4 )
	zlib? ( >=sys-libs/zlib-1.1.4 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-parallel-make.patch
	)

src_unpack() {
	default
	git-r3_src_unpack
}

src_prepare() {
	default

	sed -i -e 's/-Werror//' configure* || die

	eautoreconf
}

src_configure() {
	local myconf=""

	if use debug ; then
		myconf="--enable-debug"
	else
		myconf="--enable-fastmem"
	fi

	# NOTE about GNUTSL SSL support (from the README -- 25/12/2002)
	# As GNUTLS is not yet 100% stable and its support in ELinks is not so well
	# tested yet, it's recommended for users to give a strong preference to OpenSSL whenever possible.
	if use ssl ; then
		myconf="${myconf} --with-openssl=${EPREFIX}/usr"
	else
		myconf="${myconf} --without-openssl --without-gnutls"
	fi

	econf \
		--sysconfdir="${EPREFIX}"/etc/elinks \
		--enable-leds \
		--enable-88-colors \
		--enable-256-colors \
		--enable-true-color \
		--enable-html-highlight \
		$(use_with gpm) \
		$(use_with brotli) \
		$(use_with bzip2 bzlib) \
		$(use_with guile) \
		$(use_with idn) \
		$(use_with javascript spidermonkey) \
		$(use_with lua) \
		$(use_with perl) \
		$(use_with ruby) \
		$(use_with tre) \
		$(use_with X x) \
		$(use_with zlib) \
		$(use_enable bittorrent) \
		$(use_enable finger) \
		$(use_enable ftp) \
		$(use_enable gopher) \
		$(use_enable ipv6) \
		$(use_enable mouse) \
		$(use_enable nls) \
		$(use_enable nntp) \
		$(use_enable samba smb) \
		$(use_enable xml xbel) \
		${myconf}
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
	# colliding with the system's gettext (https://bugs.gentoo.org/635090)
	rm -f "${ED}"/usr/{share/locale/locale,lib/charset}.alias || die
}

pkg_postinst() {
	einfo "You may want to convert your html.cfg and links.cfg of"
	einfo "Links or older ELinks versions to the new ELinks elinks.conf"
	einfo "using /usr/share/doc/${PF}/contrib/conv/conf-links2elinks.pl"
	einfo
	einfo "Please have a look at /etc/elinks/keybind-full.sample and"
	einfo "/etc/elinks/keybind.conf.sample for some bindings examples."
	einfo
	einfo "You will have to set your TERM variable to 'xterm-256color'"
	einfo "to be able to use 256 colors in elinks."
}
