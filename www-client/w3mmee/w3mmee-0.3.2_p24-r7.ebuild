# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit alternatives eutils multilib toolchain-funcs

MY_PV="${PV##*_}-22"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A variant of w3m with support for multiple character encodings"
HOMEPAGE="http://pub.ks-and-ks.ne.jp/prog/w3mmee/"
SRC_URI="http://pub.ks-and-ks.ne.jp/prog/pub/${MY_P}.tar.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="amd64 ppc x86"
IUSE="gpm imlib nls ssl xface"

DEPEND=">=dev-libs/boehm-gc-7.2
	>=dev-libs/libmoe-1.5.3
	dev-lang/perl
	>=sys-libs/ncurses-5.2-r3
	>=sys-libs/zlib-1.1.3-r2
	imlib? (
		>=media-libs/imlib-1.9.8
		xface? ( media-libs/compface )
	)
	gpm? ( >=sys-libs/gpm-1.19.3-r5 )
	nls? ( sys-devel/gettext )
	ssl? ( >=dev-libs/openssl-0.9.6b )"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-boehm-gc.patch
	epatch "${FILESDIR}"/${PN}-gcc-4.4.patch
	epatch "${FILESDIR}"/${PN}-gcc-4.5.patch
	epatch "${FILESDIR}"/${PN}-glibc-2.14.patch
	epatch "${FILESDIR}"/${PN}-rc_name.patch
	epatch "${FILESDIR}"/${PN}-time.patch
	epatch "${FILESDIR}"/${PN}-tinfo.patch
	epatch "${FILESDIR}"/${PN}-w3mman.patch
	sed -i "/^AR=/s:ar:$(tc-getAR):" XMakefile || die
}

src_compile() {
	local myconf myuse
	myuse="use_cookie=y use_ansi_color=y use_history=y
		display_code=E system_code=E"

	if use ssl; then
		myconf="${myconf} --ssl-includedir=/usr/include/openssl
			--ssl-libdir=/usr/$(get_libdir)"
		myuse="${myuse} use_ssl=y use_ssl_verify=y use_digest_auth=y"
	else
		myuse="${myuse} use_ssl=n"
	fi

	if use gpm; then
		myuse="${myuse} use_mouse=y"
	else
		myuse="${myuse} use_mouse=n"
	fi

	if use nls; then
		myconf="${myconf} -locale_dir=/usr/share/locale"
	else
		myconf="${myconf} -locale_dir='(NONE)'"
	fi

	if use imlib; then
		myuse="${myuse} use_image=y use_w3mimg_x11=y
		use_w3mimg_fb=n w3mimgdisplay_setuid=n"
		if use xface; then
			myuse="${myuse} use_xface=y"
		else
			myuse="${myuse} use_xface=n"
		fi
	else
		myuse="${myuse} use_image=n"
	fi

	cat <<-EOF >> config.param
	lang=MANY
	accept_lang=en
	EOF

	env CC=$(tc-getCC) ${myuse} ./configure \
		-nonstop \
		-prefix=/usr \
		-suffix=mee \
		-auxbindir=/usr/$(get_libdir)/${PN} \
		-libdir=/usr/$(get_libdir)/${PN}/cgi-bin \
		-helpdir=/usr/share/${PN} \
		-mandir=/usr/share/man \
		-sysconfdir=/etc/${PN} \
		-model=custom \
		-libmoe=/usr/$(get_libdir) \
		-mb_h=/usr/include/moe \
		-mk_btri=/usr/libexec/moe \
		-cflags="${CFLAGS}" \
		-ldflags="${LDFLAGS}" \
		${myconf} \
		|| die

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog NEWS* README
	dohtml 00INCOMPATIBLE.html

	# w3mman and manpages conflict with those from w3m
	mv "${D}"/usr/share/man/man1/w3m{,mee}.1 || die
	mv "${D}"/usr/share/man/ja/man1/w3m{,mee}.1 || die

	docinto en
	dodoc doc/{HISTORY,README,keymap,menu}*
	dohtml doc/*

	docinto jp
	dodoc doc-jp/{HISTORY,README,keymap,menu}*
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
	if [[ ! -f /usr/bin/w3m ]]; then
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
