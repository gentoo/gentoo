# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gkrellm/gkrellm-2.3.5-r3.ebuild,v 1.10 2015/06/28 15:35:23 zlogene Exp $

EAPI=5

inherit eutils multilib user systemd toolchain-funcs

DESCRIPTION="Single process stack of various system monitors"
HOMEPAGE="http://www.gkrellm.net/"
SRC_URI="http://members.dslextreme.com/users/billw/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="gnutls hddtemp lm_sensors nls ntlm ssl kernel_FreeBSD X"

RDEPEND="
	dev-libs/glib:2
	hddtemp? ( app-admin/hddtemp )
	gnutls? ( net-libs/gnutls )
	!gnutls? ( ssl? ( dev-libs/openssl:0= ) )
	lm_sensors? ( sys-apps/lm_sensors )
	nls? ( virtual/libintl )
	ntlm? ( net-libs/libntlm )
	X? (
		x11-libs/gtk+:2
		x11-libs/pango
		)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	enewgroup gkrellmd
	enewuser gkrellmd -1 -1 -1 gkrellmd
	TARGET=
	use kernel_FreeBSD && TARGET="freebsd"
}

src_prepare() {
	sed -e 's:-O2 ::' \
		-e 's:override CC:CFLAGS:' \
		-e 's:-L/usr/X11R6/lib::' \
		-i */Makefile || die "sed Makefile(s) failed"

	sed -e "s:/usr/lib:${EPREFIX}/usr/$(get_libdir):" \
		-e "s:/usr/local/lib:${EPREFIX}/usr/local/$(get_libdir):" \
		-i src/${PN}.h || die "sed ${PN}.h failed"

	epatch \
		"${FILESDIR}"/${P}-autofs.patch \
		"${FILESDIR}"/${P}-cifs.patch \
		"${FILESDIR}"/${P}-dso.patch \
		"${FILESDIR}"/${P}-format-security.patch \
		"${FILESDIR}"/${P}-config.patch \
		"${FILESDIR}"/${P}-width.patch \
		"${FILESDIR}"/${P}-binding.patch \
		"${FILESDIR}"/${P}-sansfont.patch
}

src_compile() {
	if use X ; then
		local sslopt=""
		if use gnutls; then
			sslopt="without-ssl=yes"
		elif use ssl; then
			sslopt="without-gnutls=yes"
		else
			sslopt="without-ssl=yes without-gnutls=yes"
		fi

		emake \
			${TARGET} \
			CC="$(tc-getCC)" \
			STRIP="" \
			INSTALLROOT="${EPREFIX}/usr" \
			INCLUDEDIR="${EPREFIX}/usr/include/gkrellm2" \
			LOCALEDIR="${EPREFIX}/usr/share/locale" \
			$(usex nls "" "enable_nls=0") \
			$(usex lm_sensors "" "without-libsensors=yes") \
			$(usex ntlm "" "without-ntlm=yes") \
			${sslopt}
	else
		cd server || die
		emake \
			${TARGET} \
			CC="$(tc-getCC)" \
			LINK_FLAGS="$LDFLAGS -Wl,-E" \
			STRIP="" \
			$(usex nls "" "enable_nls=0") \
			$(usex lm_sensors "" "without-libsensors=yes")
	fi
}

src_install() {
	if use X ; then
		emake \
			install${TARGET:+_}${TARGET} \
			$(usex nls "" "enable_nls=0") \
			STRIP="" \
			INSTALLDIR="${ED}/usr/bin" \
			INCLUDEDIR="${ED}/usr/include" \
			LOCALEDIR="${ED}/usr/share/locale" \
			PKGCONFIGDIR="${ED}/usr/$(get_libdir)/pkgconfig" \
			MANDIR="${ED}/usr/share/man/man1"

		dohtml *.html

		newicon src/icon.xpm ${PN}.xpm
		make_desktop_entry ${PN} GKrellM ${PN}
	else
		dobin server/gkrellmd

		insinto /usr/include/gkrellm2
		doins server/gkrellmd.h
		doins shared/log.h
	fi

	doinitd "${FILESDIR}"/gkrellmd
	newconfd "${FILESDIR}"/gkrellmd.conf gkrellmd

	systemd_dounit "${FILESDIR}"/gkrellmd.service

	insinto /etc
	doins server/gkrellmd.conf

	dodoc Changelog CREDITS README
}
