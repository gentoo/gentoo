# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic optfeature toolchain-funcs xdg

DESCRIPTION="Single process stack of various system monitors"
HOMEPAGE="https://gkrellm.srcbox.net/"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.srcbox.net/gkrellm/gkrellm.git"
else
	SRC_URI="https://gkrellm.srcbox.net/releases/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi
LICENSE="GPL-3+"
SLOT="2"
IUSE="gnutls lm-sensors nls ntlm ssl X"
REQUIRED_USE="gnutls? ( ssl )"

RDEPEND="
	acct-group/gkrellmd
	acct-user/gkrellmd
	dev-libs/glib:2
	lm-sensors? ( sys-apps/lm-sensors:= )
	nls? ( virtual/libintl )
	X? (
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/pango
		ntlm? ( net-libs/libntlm )
		ssl? (
			gnutls? ( net-libs/gnutls:= )
			!gnutls? ( dev-libs/openssl:0= )
		)
	)
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	nls? ( sys-devel/gettext )
"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-2.5.0-config.patch"
	"${FILESDIR}/${PN}-2.3.5-width.patch"
)

src_prepare() {
	# Fix paths defined in headers for etc, themes, plugins
	sed	-e "s:/usr/lib:${EPREFIX}/usr/$(get_libdir):" \
		-e "s:/usr/local/lib:${EPREFIX}/usr/local/$(get_libdir):" \
		-i server/gkrellmd.h \
		-i src/gkrellm.h || die
	# avoid no-op warning
	if [[ -n ${EPREFIX} ]]; then
		sed -e "s:/usr/share:${EPREFIX}/usr/share:" \
			-e "s:/etc/:${EPREFIX}/etc/:" \
			-i server/gkrellmd.h \
			-i src/gkrellm.h || die
	fi

	# filter -O2 set by default
	sed -e 's:-O2::' \
		-i src/Makefile \
		-i server/Makefile || die

	default
}

src_compile() {
	# see #943935
	append-cflags -std=gnu99

	# in addition to adding EPREFIX, avoid /usr/local
	# export in src_compile for gkrellm.pc and then used during installation
	export PREFIX="${EPREFIX}/usr"

	# used for gtk/glib
	tc-export PKG_CONFIG

	export TARGET=$(usex X . server)
	local emakeargs=(
		CC=$(tc-getCC)
		AR=$(tc-getAR)

		# fix X11 path
		X11_LIBS="$($(tc-getPKG_CONFIG) --libs x11 sm ice)"

		# useflags
		enable_nls=$(usex nls)
		without-libsensors=$(usex !lm-sensors)
		without-ntlm=$(usex !ntlm)
		without-ssl=$(usex ssl $(usex gnutls) yes)
		without-gnutls=$(usex !gnutls)
	)
	emake "${emakeargs[@]}" -C ${TARGET}
}

src_install() {
	local emakeargs=(
		STRIP=
		DESTDIR="${D}"
		PKGCONFIGDIR="${ED}/usr/$(get_libdir)/pkgconfig"
		CFGDIR="${ED}/etc"
	)
	emake "${emakeargs[@]}" install -C ${TARGET}

	newinitd "${FILESDIR}"/gkrellmd.initd gkrellmd
	newconfd "${FILESDIR}"/gkrellmd.conf gkrellmd

	local DOCS=( CHANGELOG.md CREDITS README )
	local HTML_DOCS=( *.html )
	einstalldocs
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "disk temperatures monitoring" app-admin/hddtemp
}
