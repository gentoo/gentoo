# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 1. Please regularly check (even at the point of bumping) Fedora's packaging
# for needed backports at https://src.fedoraproject.org/rpms/wireplumber/tree/rawhide
#
# 2. Keep an eye on git master (for both PipeWire and WirePlumber) as things
# continue to move quickly. It's not uncommon for fixes to be made shortly
# after releases.

# TODO: Maybe get upstream to produce `meson dist` tarballs:
# - https://gitlab.freedesktop.org/wireplumber/wireplumber/-/issues/3663
# - https://gitlab.freedesktop.org/wireplumber/wireplumber/-/merge_requests/1788
#
# Generate using https://github.com/thesamesam/sam-gentoo-scripts/blob/main/niche/generate-wireplumber-docs
# Set to 1 if prebuilt, 0 if not
# (the construct below is to allow overriding from env for script)
: ${WIREPLUMBER_DOCS_PREBUILT:=1}

WIREPLUMBER_DOCS_PREBUILT_DEV=sam
WIREPLUMBER_DOCS_VERSION="$(ver_cut 1-3)"
# Default to generating docs (inc. man pages) if no prebuilt; overridden later
WIREPLUMBER_DOCS_USEFLAG="+doc"

LUA_COMPAT=( lua5-{3,4} )
PYTHON_COMPAT=( python3_{11..14} )

inherit lua-single meson python-any-r1 systemd

DESCRIPTION="Replacement for pipewire-media-session"
HOMEPAGE="https://gitlab.freedesktop.org/pipewire/wireplumber"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/pipewire/${PN}.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/pipewire/${PN}/-/archive/${PV}/${P}.tar.bz2"

	if [[ ${WIREPLUMBER_DOCS_PREBUILT} == 1 ]] ; then
		SRC_URI+=" !doc? ( https://dev.gentoo.org/~${WIREPLUMBER_DOCS_PREBUILT_DEV}/distfiles/${CATEGORY}/${PN}/${PN}-${WIREPLUMBER_DOCS_VERSION}-docs.tar.xz )"
		WIREPLUMBER_DOCS_USEFLAG="doc"
	fi

	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0/0.5"
IUSE="${WIREPLUMBER_DOCS_USEFLAG} doc elogind system-service systemd test"

REQUIRED_USE="
	${LUA_REQUIRED_USE}
	?? ( elogind systemd )
	system-service? ( systemd )
"

RESTRICT="!test? ( test )"

# introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2 ) is valid but likely only used for doc building
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/glib
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/glib-utils
	sys-devel/gettext
	doc? (
		$(python_gen_any_dep '
			dev-python/breathe[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
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
	"${FILESDIR}"/${PN}-0.5.6-config-disable-sound-server-parts.patch
)

python_check_deps() {
	if use doc; then
		python_has_version \
			"dev-python/sphinx[${PYTHON_USEDEP}]" \
			"dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]" \
			"dev-python/breathe[${PYTHON_USEDEP}]" || return 1
	else
		return 0
	fi
}

pkg_setup() {
	lua-single_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Ddaemon=true
		-Dtools=true
		-Dmodules=true
		$(meson_feature doc)
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

	if ! use doc && [[ ${WIREPLUMBER_DOCS_PREBUILT} == 1 ]] ; then
		doman "${WORKDIR}"/${PN}-${WIREPLUMBER_DOCS_VERSION}-docs/man/*/*.[0-8]
	fi

	exeinto /etc/user/init.d
	newexe "${FILESDIR}"/wireplumber.initd wireplumber

	mv "${ED}"/usr/share/doc/wireplumber/* "${ED}"/usr/share/doc/${PF} || die
	rmdir "${ED}"/usr/share/doc/wireplumber || die
}

pkg_postinst() {
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
