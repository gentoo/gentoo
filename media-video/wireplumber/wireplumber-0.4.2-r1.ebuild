# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{3,4} )

inherit lua-single meson systemd

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/pipewire/${PN}.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/pipewire/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv"
fi

DESCRIPTION="Replacement for pipewire-media-session"
HOMEPAGE="https://gitlab.freedesktop.org/pipewire/wireplumber"

LICENSE="MIT"
SLOT="0/0.4"
IUSE="systemd test"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RESTRICT="!test? ( test )"

# introspection? ( dev-libs/gobject-introspection ) is valid but likely only used for doc building
BDEPEND="
	dev-libs/glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
"

DEPEND="
	${LUA_DEPS}
	>=dev-libs/glib-2.62
	>=media-video/pipewire-0.3.32
	virtual/libc
	systemd? ( sys-apps/systemd )
"

# Any dev-lua/* deps get declared like this inside RDEPEND:
#	$(lua_gen_cond_dep '
#		dev-lua/<NAME>[${LUA_USEDEP}]
#	')
RDEPEND="${DEPEND}"

DOCS=( {NEWS,README}.rst )

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.2-meson-Build-tests-conditionally.patch
	"${FILESDIR}"/${PN}-0.4.2-lua-api-fix-object-constructors-to-fail-gracefully.patch
	"${FILESDIR}"/${PN}-0.4.2-bluez-add-basic-check-for-nil-monitor.patch
	"${FILESDIR}"/${PN}-0.4.2-v4l-add-basic-check-for-nil-monitor.patch
	"${FILESDIR}"/${PN}-0.4.2-lib-wp-device-demote-missing-SPA-warning-to-message.patch
)

src_configure() {
	local emesonargs=(
		-Dintrospection=disabled # Only used for Sphinx doc generation
		-Dsystem-lua=true # We always unbundle everything we can
		-Dsystem-lua-version=$(ver_cut 1-2 $(lua_get_version))
		$(meson_feature systemd)
		-Dsystemd-system-service=false # Matches upstream
		$(meson_use systemd systemd-user-service)
		-Dsystemd-system-unit-dir=$(systemd_get_systemunitdir)
		-Dsystemd-user-unit-dir=$(systemd_get_userunitdir)
		$(meson_use test tests)
	)

	meson_src_configure
}

pkg_postinst() {
	if systemd_is_booted ; then
		elog "To replace media-session with WirePlumber immediately:"
		elog "systemctl --user disable --now pipewire-media-session.service"
		elog "systemctl --user enable --now wireplumber.service"
	else
		elog "OpenRC users need to copy ${EROOT}/usr/share/pipewire/pipewire.conf"
		elog "to ${EROOT}/etc/pipewire/pipewire.conf and in it replace"
		elog "${EROOT}/usr/bin/pipewire-media-session with ${EROOT}/usr/bin/wireplumber"
		elog "The switch to WirePlumber will happen the next time pipewire is started."
	fi
	elog
}
