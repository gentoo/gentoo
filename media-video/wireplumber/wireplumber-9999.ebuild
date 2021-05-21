# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-3 )

inherit lua-single meson

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/pipewire/${PN}.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/pipewire/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Replacement for pipewire-media-session"
HOMEPAGE="https://gitlab.freedesktop.org/pipewire/wireplumber"

LICENSE="MIT"
SLOT="0/0.4"
IUSE="systemd"

REQUIRED_USE="${LUA_REQUIRED_USE}"

# introspection? ( dev-libs/gobject-introspection ) is valid but likely only used for doc building
BDEPEND="
	dev-libs/glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
"

DEPEND="
	${LUA_DEPS}
	>=dev-libs/glib-2.58
	>=media-video/pipewire-0.3.26
	virtual/libc
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
		-Dintrospection=disabled # Likely only used for doc generation
		-Ddocs=disabled # Literally not worth dealing with right now
		-Dsystem-lua=true # We always unbundle everything we can
		$(meson_feature systemd)
		-Dsystemd-system-service=false # Matches upstream
		$(meson_feature systemd Dsystemd-user-service)
		#-Dsystemd-system-unit-dir=""
		#-Dsystemd-user-unit-dir=""
		-Dwpipc=disabled # Upstream commit 5efb46a3: embedded only; no good reason to use it on desktop
	)

	meson_src_configure
}

src_install() {
	# No idea if this is needed with meson but eclass example has this for emake
	LUA_VERSION="$(lua_get_version)" meson_src_install
}

pkg_postinst() {
	elog "To replace pipewire-media-session with wireplumber:"
	elog "systemctl --user disable --now pipewire-media-session.service"
	elog "systemctl --user enable --now wireplumber.service"
	elog
}
