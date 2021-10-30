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
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

DESCRIPTION="Replacement for pipewire-media-session"
HOMEPAGE="https://gitlab.freedesktop.org/pipewire/wireplumber"

LICENSE="MIT"
SLOT="0/0.4"
IUSE="elogind systemd test"

REQUIRED_USE="
	${LUA_REQUIRED_USE}
	?? ( elogind systemd )
"

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
	>=media-video/pipewire-0.3.39
	virtual/libc
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
"

# Any dev-lua/* deps get declared like this inside RDEPEND:
#	$(lua_gen_cond_dep '
#		dev-lua/<NAME>[${LUA_USEDEP}]
#	')
RDEPEND="${DEPEND}"

DOCS=( {NEWS,README}.rst )

src_configure() {
	local emesonargs=(
		-Dintrospection=disabled # Only used for Sphinx doc generation
		-Dsystem-lua=true # We always unbundle everything we can
		-Dsystem-lua-version=$(ver_cut 1-2 $(lua_get_version))
		$(meson_feature elogind)
		$(meson_feature systemd)
		-Dsystemd-system-service=false # Matches upstream
		$(meson_use systemd systemd-user-service)
		-Dsystemd-system-unit-dir=$(systemd_get_systemunitdir)
		-Dsystemd-user-unit-dir=$(systemd_get_userunitdir)
		$(meson_use test tests)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	insinto /usr/lib/systemd/user-preset
	doins "${FILESDIR}"/60-wireplumber.preset
}

pkg_postinst() {
	if systemd_is_booted ; then
		systemctl --global preset pipewire{,-pulse}.socket wireplumber.service

		elog "PipeWire with WirePlumber has been set up to be started by default on"
		elog "user login. If you do not like that you can undo this by masking"
		elog "wireplumber.service and pipewire{,-pulse}.socket as appropriate."
	else
		elog "Switch to WirePlumber will happen the next time gentoo-pipewire-launcher"
		elog "is started (a replacement for directly calling pipewire binary)."
	fi
	elog
}
