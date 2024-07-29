# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 1. Please regularly check (even at the point of bumping) Fedora's packaging
# for needed backports at https://src.fedoraproject.org/rpms/wireplumber/tree/rawhide
#
# 2. Keep an eye on git master (for both PipeWire and WirePlumber) as things
# continue to move quickly. It's not uncommon for fixes to be made shortly
# after releases.

LUA_COMPAT=( lua5-{3,4} )

inherit lua-single meson systemd

DESCRIPTION="Replacement for pipewire-media-session"
HOMEPAGE="https://gitlab.freedesktop.org/pipewire/wireplumber"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/pipewire/${PN}.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/pipewire/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0/0.5"
IUSE="elogind system-service systemd test"

REQUIRED_USE="
	${LUA_REQUIRED_USE}
	?? ( elogind systemd )
	system-service? ( systemd )
"

RESTRICT="!test? ( test )"

# introspection? ( dev-libs/gobject-introspection ) is valid but likely only used for doc building
BDEPEND="
	dev-libs/glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
	sys-devel/gettext
	test? ( sys-apps/dbus )
"
DEPEND="
	${LUA_DEPS}
	>=dev-libs/glib-2.68
	>=media-video/pipewire-1.0.5-r1:=
	virtual/libintl
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
"
RDEPEND="
	${DEPEND}
	system-service? (
		acct-user/pipewire
		acct-group/pipewire
	)
"

DOCS=( {NEWS,README}.rst )

PATCHES=(
	# Defer enabling sound server parts to media-video/pipewire
	# TODO: Soon, we should be able to migrate to just a dropin at
	# /usr/share. See https://gitlab.freedesktop.org/pipewire/wireplumber/-/issues/652#note_2399735.
	"${FILESDIR}"/${PN}-0.4.81-config-disable-sound-server-parts.patch
)

src_configure() {
	local emesonargs=(
		-Ddaemon=true
		-Dtools=true
		-Dmodules=true
		# Ebuild not wired up yet (Sphinx, Doxygen?)
		-Ddoc=disabled
		# Only used for Sphinx doc generation
		-Dintrospection=disabled
		-Dsystem-lua=true
		-Dsystem-lua-version=$(ver_cut 1-2 $(lua_get_version))
		$(meson_feature elogind)
		$(meson_feature systemd)
		$(meson_use system-service systemd-system-service)
		$(meson_use systemd systemd-user-service)
		-Dsystemd-system-unit-dir=$(systemd_get_systemunitdir)
		-Dsystemd-user-unit-dir=$(systemd_get_userunitdir)
		$(meson_use test tests)
		$(meson_use test dbus-tests)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	mv "${ED}"/usr/share/doc/wireplumber/* "${ED}"/usr/share/doc/${PF} || die
	rmdir "${ED}"/usr/share/doc/wireplumber || die
}

pkg_postinst() {
	if systemd_is_booted ; then
		ewarn "pipewire-media-session.service is no longer installed. You must switch"
		ewarn "to wireplumber.service user unit before your next logout/reboot:"
		ewarn "systemctl --user disable pipewire-media-session.service"
		ewarn "systemctl --user --force enable wireplumber.service"
	else
		ewarn "Switch to WirePlumber will happen the next time gentoo-pipewire-launcher"
		ewarn "is started (a replacement for directly calling pipewire binary)."
		ewarn
		ewarn "Please ensure that ${EROOT}/etc/pipewire/pipewire.conf either does not exist"
		ewarn "or, if it does exist, that any reference to"
		ewarn "${EROOT}/usr/bin/pipewire-media-session is commented out (begins with a #)."
	fi

	if use system-service; then
		ewarn
		ewarn "WARNING: you have enabled the system-service USE flag, which installs"
		ewarn "the system-wide systemd units that enable WirePlumber to run as a system"
		ewarn "service. This is more than likely NOT what you want. You are strongly"
		ewarn "advised not to enable this mode and instead stick with systemd user"
		ewarn "units. The default configuration files will likely not work out of"
		ewarn "box, and you are on your own with configuration."
		ewarn
	fi
}
