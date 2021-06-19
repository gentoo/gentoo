# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools cannadic toolchain-funcs

MY_P="Canna${PV//[._]/}"

DESCRIPTION="A client-server based Kana-Kanji conversion system"
HOMEPAGE="http://canna.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/9565/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="canuum doc ipv6"

RDEPEND="
	canuum? (
		dev-libs/libspt
		sys-libs/ncurses:=
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	x11-misc/gccmakedep
	x11-misc/imake
	canuum? ( virtual/pkgconfig )
	doc? (
		app-text/ghostscript-gpl
		dev-texlive/texlive-langjapanese
		dev-texlive/texlive-latexrecommended
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-canuum.patch
	"${FILESDIR}"/${PN}-kpdef.patch
	"${FILESDIR}"/${PN}-overflow.patch
	"${FILESDIR}"/${PN}-posix-sort.patch
	"${FILESDIR}"/${PN}-Wformat.patch
	"${FILESDIR}"/${PN}-Wformat-security.patch
)

src_prepare() {
	default

	sed -i \
		-e "/DefLibCannaDir/s:/lib$:/$(get_libdir):" \
		-e "/UseInet6/s:0:$(usex ipv6 1 0):" \
		${PN^c}.conf || die

	if use canuum; then
		cd canuum || die
		mv configure.{in,ac} || die
		eautoreconf
	fi
}

src_configure() {
	xmkmf -a || die

	if use canuum; then
		pushd canuum >/dev/null || die
		xmkmf -a || die
		# workaround for sys-libs/ncurses[tinfo]
		sed -i "/^TERMCAP_LIB/s:=.*:=$($(tc-getPKG_CONFIG) --libs ncurses):" Makefile || die
		popd >/dev/null || die
	fi

	if use doc; then
		pushd doc/man/guide/tex >/dev/null || die
		xmkmf -a || die
		popd >/dev/null || die
	fi
}

src_compile() {
	# bug #279706
	emake -j1 \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		SHLIBGLOBALSFLAGS="${LDFLAGS}" \
		canna

	if use canuum; then
		einfo "Compiling canuum"
		emake -C canuum -j1 \
			CC="$(tc-getCC)" \
			CDEBUGFLAGS="${CFLAGS}" \
			LOCAL_LDFLAGS="${LDFLAGS}" \
			canuum
	fi

	if use doc; then
		# NOTE: build fails if infinality enabled in fontconfig
		einfo "Compiling DVI, PS, and PDF documents"
		# bug #223077
		emake -C doc/man/guide/tex -j1 \
			JLATEXCMD="platex -kanji=euc" \
			DVI2PSCMD="dvips" \
			VARTEXFONTS="${T}"/fonts \
			canna.ps \
			canna.pdf
	fi
}

src_install() {
	emake DESTDIR="${D}" install install.man
	einstalldocs
	dodoc *CHANGES* INSTALL* RKCCONF* WHATIS*

	if use canuum; then
		emake -C canuum DESTDIR="${D}" install install.man
		docinto canuum
		dodoc README.jp
	fi

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/man/guide/tex/canna.{dvi,ps,pdf}
	fi

	# for backward compatibility
	dosbin "${FILESDIR}"/update-canna-dics_dir

	keepdir /var/lib/canna/dic/{user,group}
	fowners bin:bin /var/lib/canna/dic/{user,group}
	fperms 0775 /var/lib/canna/dic/{user,group}

	insinto /var/lib/canna/dic/dics.d
	newins "${ED}"/var/lib/canna/dic/canna/dics.dir 00canna.dics.dir

	keepdir /var/log/canna

	newconfd "${FILESDIR}"/canna.confd canna
	newinitd "${FILESDIR}"/canna.initd canna

	insinto /etc
	newins "${FILESDIR}"/canna.hosts hosts.canna
}

pkg_postinst() {
	update-cannadic-dir

	if ! locale -a | grep -iq "ja_JP.eucjp"; then
		elog "Some dictionary tools in this package require ja_JP.EUC-JP locale."
		elog
		elog "# echo 'ja_JP.EUC-JP EUC-JP' >> ${EROOT}/etc/locale.gen"
		elog "# locale-gen"
		elog
	fi
}
