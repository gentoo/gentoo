# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/w3mmee/w3mmee-0.3.2_p24-r7.ebuild,v 1.12 2014/07/05 01:18:42 naota Exp $

inherit alternatives eutils toolchain-funcs multilib

IUSE="gpm imlib nls ssl xface"

MY_PV=${PV##*_}-22
MY_P=${PN}-${MY_PV}

DESCRIPTION="A variant of w3m with support for multiple character encodings"
SRC_URI="http://pub.ks-and-ks.ne.jp/prog/pub/${MY_P}.tar.gz"
HOMEPAGE="http://pub.ks-and-ks.ne.jp/prog/w3mmee/"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="amd64 ppc x86"

DEPEND=">=sys-libs/ncurses-5.2-r3
	>=sys-libs/zlib-1.1.3-r2
	>=dev-libs/boehm-gc-7.2
	dev-lang/perl
	>=dev-libs/libmoe-1.5.3
	imlib? ( >=media-libs/imlib-1.9.8
		xface? ( media-libs/compface ) )
	gpm? ( >=sys-libs/gpm-1.19.3-r5 )
	nls? ( sys-devel/gettext )
	ssl? ( >=dev-libs/openssl-0.9.6b )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-w3mman-gentoo.diff \
		"${FILESDIR}"/${PN}-gcc4{4,5}.patch \
		"${FILESDIR}"/${P}-glibc214.patch \
		"${FILESDIR}"/${P}-tinfo.patch \
		"${FILESDIR}"/${P}-boehm-gc.patch
	sed -ie "/^AR=/s:ar:$(tc-getAR):" XMakefile || die
}

src_compile() {

	local myconf myuse
	myuse="use_cookie=y use_ansi_color=y use_history=y
		display_code=E system_code=E"

	if use ssl ; then
		myconf="${myconf} --ssl-includedir=/usr/include/openssl
			--ssl-libdir=/usr/$(get_libdir)"
		myuse="${myuse} use_ssl=y use_ssl_verify=y use_digest_auth=y"
	else
		myuse="${myuse} use_ssl=n"
	fi

	if use gpm ; then
		myuse="${myuse} use_mouse=y"
	else
		myuse="${myuse} use_mouse=n"
	fi

	if use nls ; then
		myconf="${myconf} -locale_dir=/usr/share/locale"
	else
		myconf="${myconf} -locale_dir='(NONE)'"
	fi

	if use imlib ; then
		myuse="${myuse} use_image=y use_w3mimg_x11=y
		use_w3mimg_fb=n w3mimgdisplay_setuid=n"
		if use xface ; then
			myuse="${myuse} use_xface=y"
		else
			myuse="${myuse} use_xface=n"
		fi
	else
		myuse="${myuse} use_image=n"
	fi

	cat >>config.param<<-EOF
	lang=MANY
	accept_lang=en
	EOF

	env CC=$(tc-getCC) ${myuse} ./configure -nonstop \
		-prefix=/usr \
		-suffix=mee \
		-auxbindir=/usr/$(get_libdir)/w3mmee \
		-libdir=/usr/$(get_libdir)/w3mmee/cgi-bin \
		-helpdir=/usr/share/w3mmee \
		-mandir=/usr/share/man \
		-sysconfdir=/etc/w3mmee \
		-model=custom \
		-libmoe=/usr/$(get_libdir) \
		-mb_h=/usr/include/moe \
		-mk_btri=/usr/libexec/moe \
		-cflags="${CFLAGS}" -ldflags="${LDFLAGS}" \
		${myconf} || die

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die

	# w3mman and manpages conflict with those from w3m
	mv "${D}"/usr/share/man/ja/man1/w3m{,mee}.1 || die
	mv "${D}"/usr/share/man/man1/w3m{,mee}.1 || die

	dodoc ChangeLog NEWS* README
	dohtml 00INCOMPATIBLE.html

	docinto en
	dodoc doc/HISTORY doc/README* doc/keymap.* doc/menu.*
	dohtml doc/*

	docinto jp
	dodoc doc-jp/HISTORY doc-jp/README* doc-jp/keymap* doc-jp/menu.*
	dohtml doc-jp/*
}

pkg_postinst() {

	w3m_alternatives
	einfo
	einfo "If you want to render multilingual text, please refer to"
	einfo "/usr/share/doc/${PF}/en/README.mee or"
	einfo "/usr/share/doc/${PF}/jp/README.mee"
	einfo "and set W3MLANG variable respectively."
	einfo
}

pkg_postrm() {

	w3m_alternatives
}

w3m_alternatives() {

	if [ ! -f /usr/bin/w3m ] ; then
		alternatives_makesym /usr/bin/w3m \
			/usr/bin/w3m{m17n,mee}
		alternatives_makesym /usr/bin/w3mman \
			/usr/bin/w3m{man-m17n,meeman}
		alternatives_makesym /usr/share/man/ja/man1/w3m.1.gz \
			/usr/share/man/ja/man1/w3m{m17n,mee}.1.gz
		alternatives_makesym /usr/share/man/man1/w3m.1.gz \
			/usr/share/man/man1/w3m{m17n,mee}.1.gz
		alternatives_makesym /usr/share/man/man1/w3mman.1.gz \
			/usr/share/man/man1/w3m{man-m17n,meeman}.1.gz
	fi
}
