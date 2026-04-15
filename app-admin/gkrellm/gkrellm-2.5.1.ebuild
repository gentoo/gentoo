# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature xdg

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
IUSE="gnutls lm-sensors nls ntlm +server ssl systemd X"
REQUIRED_USE="
	|| ( server X )
	gnutls? ( ssl )
"

RDEPEND="
	acct-group/gkrellmd
	acct-user/gkrellmd
	>=dev-libs/glib-2.32:2
	lm-sensors? ( sys-apps/lm-sensors:= )
	nls? ( virtual/libintl )
	systemd? ( sys-apps/systemd )
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
	nls? ( sys-devel/gettext )
	X? ( x11-base/xorg-proto )
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

	default
}

src_configure() {
	local enable_ssl="none"
	if use ssl; then
		enable_ssl="openssl"
	fi
	if use gnutls; then
		enable_ssl="gnutls"
	fi

	local emesonargs=(
		-Dssl=${enable_ssl}
		$(meson_use server build-server)
		$(meson_use X build-client)
		$(meson_feature lm-sensors lmsensors)
		$(meson_feature nls)
		$(meson_feature ntlm)
		$(meson_feature systemd)
	)
	meson_src_configure
}

src_install() {
	newinitd "${FILESDIR}"/gkrellmd.initd gkrellmd
	newconfd "${FILESDIR}"/gkrellmd.conf gkrellmd

	local DOCS=( CHANGELOG.md CREDITS README )
	local HTML_DOCS=( *.html )
	meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "disk temperatures monitoring" app-admin/hddtemp
}
