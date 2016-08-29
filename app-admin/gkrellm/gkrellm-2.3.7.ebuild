# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils multilib user systemd toolchain-funcs

MY_P="${P/_/-}"

DESCRIPTION="Single process stack of various system monitors"
HOMEPAGE="http://www.gkrellm.net/"
SRC_URI="http://gkrellm.srcbox.net/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="gnutls hddtemp libressl lm_sensors nls ntlm ssl kernel_FreeBSD X"

RDEPEND="
	dev-libs/glib:2
	hddtemp? ( app-admin/hddtemp )
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		ssl? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)
	lm_sensors? ( sys-apps/lm_sensors )
	nls? ( virtual/libintl )
	ntlm? ( net-libs/libntlm )
	X? (
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/pango
		)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.5-cifs.patch
	"${FILESDIR}"/${PN}-2.3.5-config.patch
	"${FILESDIR}"/${PN}-2.3.5-width.patch
	"${FILESDIR}"/${PN}-2.3.5-sansfont.patch
	"${FILESDIR}"/${P}-pkgconfig_fix_newlines.patch
)

S="${WORKDIR}/${MY_P}"

DOCS=( Changelog CREDITS README )

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

	default
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

		docinto html
		dodoc *.html

		newicon src/icon.xpm ${PN}.xpm
		make_desktop_entry ${PN} GKrellM ${PN}
	else
		dobin server/gkrellmd

		insinto /usr/include/gkrellm2
		doins server/gkrellmd.h
		doins shared/log.h
	fi

	newinitd "${FILESDIR}"/gkrellmd.initd gkrellmd
	newconfd "${FILESDIR}"/gkrellmd.conf gkrellmd

	systemd_dounit "${FILESDIR}"/gkrellmd.service

	insinto /etc
	doins server/gkrellmd.conf

	einstalldocs
}
