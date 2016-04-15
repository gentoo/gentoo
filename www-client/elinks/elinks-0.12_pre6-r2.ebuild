# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils autotools flag-o-matic

MY_P="${P/_/}"
DESCRIPTION="Advanced and well-established text-mode web browser"
HOMEPAGE="http://elinks.or.cz/"
SRC_URI="http://elinks.or.cz/download/${MY_P}.tar.bz2
	https://dev.gentoo.org/~spock/portage/distfiles/elinks-0.10.4.conf.bz2
	https://dev.gentoo.org/~axs/distfiles/${PN}-0.12_pre5-js185-patches.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="bittorrent bzip2 debug finger ftp gc gopher gpm guile idn ipv6
	  javascript libressl lua +mouse nls nntp perl ruby samba ssl unicode X xml zlib"
RESTRICT="test"

DEPEND="
	bzip2? ( >=app-arch/bzip2-1.0.2 )
	gc? ( dev-libs/boehm-gc )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	xml? ( >=dev-libs/expat-1.95.4 )
	X? ( x11-libs/libX11 x11-libs/libXt )
	zlib? ( >=sys-libs/zlib-1.1.4 )
	lua? ( >=dev-lang/lua-5:0 )
	gpm? ( >=sys-libs/ncurses-5.2:0 >=sys-libs/gpm-1.20.0-r5 )
	guile? ( >=dev-scheme/guile-1.6.4-r1[deprecated,discouraged] )
	idn? ( net-dns/libidn )
	perl? ( dev-lang/perl )
	ruby? ( dev-lang/ruby:= dev-ruby/rubygems )
	samba? ( net-fs/samba )
	javascript? ( dev-lang/spidermonkey:0 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cd "${WORKDIR}"
	epatch "${FILESDIR}"/${PN}-0.10.4.conf-syscharset.diff
	mv "${PN}-0.10.4.conf" "${PN}.conf"
	if ! use ftp ; then
		sed -i -e 's/\(.*protocol.ftp.*\)/# \1/' ${PN}.conf
	fi
	sed -i -e 's/\(.*set protocol.ftp.use_epsv.*\)/# \1/' ${PN}.conf
	cd "${S}"

	if use lua && has_version ">=dev-lang/lua-5.1"; then
		epatch "${FILESDIR}"/${PN}-0.11.2-lua-5.1.patch
	fi

	epatch "${FILESDIR}"/${PN}-9999-parallel-make.patch
	epatch "${FILESDIR}"/${PN}-0.12_pre5-compilation-fix.patch

	if use javascript ; then
		if has_version ">=dev-lang/spidermonkey-1.8"; then
			if has_version ">=dev-lang/spidermonkey-1.8.5"; then
				epatch "${WORKDIR}"/patches/${PN}-0.12_pre5-js185-1-heartbeat.patch
				epatch "${WORKDIR}"/patches/${PN}-0.12_pre5-js185-2-up.patch
				epatch "${WORKDIR}"/patches/${PN}-0.12_pre5-js185-3-histback.patch
				epatch "${FILESDIR}"/${PN}-0.12_pre5-sm185-jsval-fixes.patch
#				if has_version ">=dev-lang/spidermonkey-1.8.7"; then
#					# fix lib order in configure check and add mozjs187
#					# (these seds are necessary so that @preserved-libs copies are not used)
#					sed -i -e 's:for spidermonkeylib in js .*$:for spidermonkeylib in mozjs187 mozjs185 mozjs js smjs; do:' \
#						configure.in || die
#				else
					# fix lib order in configure check
					# (these seds are necessary so that @preserved-libs copies are not used)
					sed -i -e 's:for spidermonkeylib in js .*$:for spidermonkeylib in mozjs185 mozjs js smjs; do:' \
						configure.in || die
#				fi
			else
				# fix lib order in configure check
				# (these seds are necessary so that @preserved-libs copies are not used)
				epatch "${FILESDIR}"/${MY_P}-spidermonkey-callback.patch
				sed -i -e 's:for spidermonkeylib in js .*$:for spidermonkeylib in mozjs js smjs; do:' \
					configure.in || die
			fi
		fi
	fi
	epatch "${FILESDIR}"/${PN}-0.12_pre5-ruby-1.9.patch
	# Regenerate acinclude.m4 - based on autogen.sh.
	cat > acinclude.m4 <<- _EOF
		dnl Automatically generated from config/m4/ files.
		dnl Do not modify!
	_EOF
	cat config/m4/*.m4 >> acinclude.m4

	sed -i -e 's/-Werror//' configure*

	eautoreconf
}

src_configure() {
	# NOTE about GNUTSL SSL support (from the README -- 25/12/2002)
	# As GNUTLS is not yet 100% stable and its support in ELinks is not so well
	# tested yet, it's recommended for users to give a strong preference to OpenSSL whenever possible.
	local myconf=""

	if use debug ; then
		myconf="--enable-debug"
	else
		myconf="--enable-fastmem"
	fi

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
		$(use_with zlib) \
		$(use_with bzip2 bzlib) \
		$(use_with gc) \
		$(use_with X x) \
		$(use_with lua) \
		$(use_with guile) \
		$(use_with perl) \
		$(use_with ruby) \
		$(use_with idn) \
		$(use_with javascript spidermonkey) \
		$(use_enable bittorrent) \
		$(use_enable nls) \
		$(use_enable ipv6) \
		$(use_enable ftp) \
		$(use_enable gopher) \
		$(use_enable nntp) \
		$(use_enable finger) \
		$(use_enable samba smb) \
		$(use_enable mouse) \
		$(use_enable xml xbel) \
		${myconf}
}

src_compile() {
	emake V=1
}

src_install() {
	emake V=1 DESTDIR="${D}" install

	insopts -m 644 ; insinto /etc/elinks
	doins "${WORKDIR}"/elinks.conf
	newins contrib/keybind-full.conf keybind-full.sample
	newins contrib/keybind.conf keybind.conf.sample

	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS README SITES THANKS TODO doc/*.*
	docinto contrib ; dodoc contrib/{README,colws.diff,elinks[-.]vim*}
	insinto /usr/share/doc/${PF}/contrib/lua ; doins contrib/lua/{*.lua,elinks-remote}
	insinto /usr/share/doc/${PF}/contrib/conv ; doins contrib/conv/*.*
	insinto /usr/share/doc/${PF}/contrib/guile ; doins contrib/guile/*.scm

	# Remove some conflicting files on OSX.  The files provided by OSX 10.4
	# are more or less the same.  -- Fabian Groffen (2005-06-30)
	rm -f "${ED}"/usr/share/locale/locale.alias "${ED}"/usr/lib/charset.alias || die
}

pkg_postinst() {
	einfo "This ebuild provides a default config for ELinks."
	einfo "Please check /etc/elinks/elinks.conf"
	einfo
	einfo "You may want to convert your html.cfg and links.cfg of"
	einfo "Links or older ELinks versions to the new ELinks elinks.conf"
	einfo "using /usr/share/doc/${PF}/contrib/conv/conf-links2elinks.pl"
	einfo
	einfo "Please have a look at /etc/elinks/keybind-full.sample and"
	einfo "/etc/elinks/keybind.conf.sample for some bindings examples."
	einfo
	einfo "You will have to set your TERM variable to 'xterm-256color'"
	einfo "to be able to use 256 colors in elinks."
	echo
}
