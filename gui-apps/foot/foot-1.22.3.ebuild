# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson systemd verify-sig xdg

DESCRIPTION="Fast, lightweight and minimalistic Wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"
SRC_URI="
	https://codeberg.org/dnkl/foot/releases/download/${PV}/${P}.tar.gz
	verify-sig? ( https://codeberg.org/dnkl/foot/releases/download/${PV}/${P}.tar.gz.sig )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+grapheme-clustering test utempter verify-sig"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/wayland
	>=media-libs/fcft-3.3.1
	media-libs/fontconfig
	x11-libs/libxkbcommon
	x11-libs/pixman
	grapheme-clustering? (
		dev-libs/libutf8proc:=[-cjk]
		media-libs/fcft[harfbuzz]
	)
"
DEPEND="
	${COMMON_DEPEND}
	>=dev-libs/tllist-1.1.0
	>=dev-libs/wayland-protocols-1.41
"
RDEPEND="
	${COMMON_DEPEND}
	|| (
		~gui-apps/foot-terminfo-${PV}
		>=sys-libs/ncurses-6.3[-minimal]
	)
	utempter? ( sys-libs/libutempter )
"
BDEPEND="
	app-text/scdoc
	dev-util/wayland-scanner
	verify-sig? ( sec-keys/openpgp-keys-dnkl )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/dnkl.asc

src_prepare() {
	default

	# disable the systemd dep, we install the unit file manually
	sed -i "s/systemd', required: false)$/', required: false)/" meson.build || die

	# adjust install dir
	sed -i "s/'doc', 'foot'/'doc', '${PF}'/" meson.build || die

	# do not install LICENSE file
	sed -i "s/'LICENSE', //" meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddocs=enabled
		-Dthemes=true
		-Dime=true
		-Dterminfo=disabled
		$(meson_feature grapheme-clustering)
		$(meson_use test tests)
		-Dutmp-backend=$(usex utempter libutempter none)
		-Dutmp-default-helper-path="/usr/$(get_libdir)/misc/utempter/utempter"
	)
	meson_src_configure

	sed 's|@bindir@|/usr/bin|g' "${S}"/foot-server.service.in > foot-server.service || die
}

src_install() {
	meson_src_install

	exeinto /etc/user/init.d
	newexe "${FILESDIR}/foot.initd" foot
	systemd_douserunit foot-server.service "${S}"/foot-server.socket
}

pkg_postinst() {
	xdg_pkg_postinst
}
