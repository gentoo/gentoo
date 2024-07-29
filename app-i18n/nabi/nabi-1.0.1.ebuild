# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Simple Hanguk X Input Method"
HOMEPAGE="https://github.com/libhangul/nabi"
SRC_URI="https://github.com/libhangul/nabi/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}"/${PN}-${P}

LICENSE="GPL-2"
SLOT="0"
IUSE="debug nls"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=app-i18n/libhangul-0.1
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	virtual/libintl
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog.0 NEWS README TODO )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myconf=()

	# Broken configure: --disable-debug also enables debug
	use debug && myconf+=( --enable-debug )

	econf "${myconf[@]}"
}

src_install() {
	default

	insinto /etc/X11/xinit/xinput.d
	sed -e "s:@EPREFIX@:${EPREFIX}:g" "${FILESDIR}"/xinput-${PN} | newins - ${PN}.conf
}

pkg_postinst() {
	elog "You MUST add environment variable..."
	elog
	elog "export XMODIFIERS=\"@im=nabi\""
	elog
}
