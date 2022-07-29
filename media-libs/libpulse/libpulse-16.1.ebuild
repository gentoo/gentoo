# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PV="${PV/_pre*}"
MY_P="pulseaudio-${MY_PV}"
inherit bash-completion-r1 gnome2-utils meson-multilib optfeature systemd udev

DESCRIPTION="Libraries for PulseAudio clients"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/PulseAudio/"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/pulseaudio/pulseaudio"
else
	SRC_URI="https://freedesktop.org/software/pulseaudio/releases/${MY_P}.tar.xz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1+"

SLOT="0"
IUSE="+asyncns dbus doc +glib gtk selinux systemd test valgrind X"
RESTRICT="!test? ( test )"

# NOTE: libpcre needed in some cases, bug #472228
# TODO: libatomic_ops is only needed on some architectures and conditions, and then at runtime too
RDEPEND="
	dev-libs/libatomic_ops
	>=media-libs/libsndfile-1.0.20[${MULTILIB_USEDEP}]
	virtual/libc
	asyncns? ( >=net-libs/libasyncns-0.1[${MULTILIB_USEDEP}] )
	dbus? ( >=sys-apps/dbus-1.4.12[${MULTILIB_USEDEP}] )
	glib? ( >=dev-libs/glib-2.28.0:2[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:3 )
	selinux? ( sec-policy/selinux-pulseaudio )
	systemd? ( sys-apps/systemd:= )
	valgrind? ( dev-util/valgrind )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.6[${MULTILIB_USEDEP}]
	)
	|| (
		elibc_glibc? ( virtual/libc )
		dev-libs/libpcre:3
	)
	!<media-sound/pulseaudio-15.0-r100
"

DEPEND="${RDEPEND}
	test? ( >=dev-libs/check-0.9.10 )
	X? ( x11-base/xorg-proto )
"

# pulseaudio ships a bundled xmltoman, which uses XML::Parser
BDEPEND="
	dev-lang/perl
	dev-perl/XML-Parser
	sys-devel/gettext
	sys-devel/m4
	virtual/libiconv
	virtual/libintl
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
PDEPEND="
	|| (
		media-video/pipewire[sound-server(+)]
		media-sound/pulseaudio-daemon
		media-sound/pulseaudio[daemon(+)]
	)
"

DOCS=( NEWS README )

# patches merged upstream, to be removed with 16.2 or later bump
PATCHES=(
)

src_prepare() {
	default

	# disable autospawn by client
	sed -i -e 's:; autospawn = yes:autospawn = no:g' src/pulse/client.conf.in || die

	gnome2_environment_reset
}

multilib_src_configure() {
	local emesonargs=(
		--localstatedir="${EPREFIX}"/var

		-Ddaemon=false
		-Dclient=true
		$(meson_native_use_bool doc doxygen)
		-Dgcov=false
		# tests involve random modules, so just do them for the native # TODO: tests should run always
		$(meson_native_use_bool test tests)
		-Ddatabase=simple # Not used for non-daemon, simple database avoids external dep checks
		-Dstream-restore-clear-old-devices=true
		-Drunning-from-build-tree=false

		# Paths
		-Dmodlibexecdir="${EPREFIX}/usr/$(get_libdir)/pulseaudio/modules" # Was $(get_libdir)/${P}
		-Dsystemduserunitdir=$(systemd_get_userunitdir)
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)/rules.d"
		-Dbashcompletiondir="$(get_bashcompdir)" # Alternatively DEPEND on app-shells/bash-completion for pkg-config to provide the value

		# Optional features
		-Dalsa=disabled
		$(meson_feature asyncns)
		-Davahi=disabled
		-Dbluez5=disabled
		-Dbluez5-gstreamer=disabled
		-Dbluez5-native-headset=false
		-Dbluez5-ofono-headset=false
		$(meson_feature dbus)
		-Delogind=disabled
		-Dfftw=disabled
		$(meson_feature glib) # WARNING: toggling this likely changes ABI
		-Dgsettings=disabled
		-Dgstreamer=disabled
		$(meson_native_use_feature gtk)
		-Dhal-compat=false
		-Dipv6=true
		-Djack=disabled
		-Dlirc=disabled
		-Dopenssl=disabled
		-Dorc=disabled
		-Doss-output=disabled
		-Dsamplerate=disabled # Matches upstream
		-Dsoxr=disabled
		-Dspeex=disabled
		$(meson_native_use_feature systemd)
		-Dtcpwrap=disabled
		-Dudev=disabled
		$(meson_native_use_feature valgrind)
		$(meson_feature X x11)

		# Echo cancellation
		-Dadrian-aec=false
		-Dwebrtc-aec=disabled
	)

	if multilib_is_native_abi; then
		# Make padsp work for non-native ABI, supposedly only possible with glibc;
		# this is used by /usr/bin/padsp that comes from native build, thus we need
		# this argument for native build
		if use elibc_glibc; then
			emesonargs+=( -Dpulsedsp-location="${EPREFIX}"'/usr/\\$$LIB/pulseaudio' )
		fi
	else
		emesonargs+=( -Dman=false )
		if ! use elibc_glibc; then
			# Non-glibc multilib is probably non-existent but just in case:
			ewarn "padsp wrapper for OSS emulation will only work with native ABI applications!"
		fi
	fi

	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile

	if multilib_is_native_abi; then
		if use doc; then
			einfo "Generating documentation ..."
			meson_src_compile doxygen
		fi
	fi
}

multilib_src_install() {
	# The files referenced in the DOCS array do not exist in the multilib source directory,
	# therefore clear the variable when calling the function that will access it.
	DOCS= meson_src_install

	# Upstream installs 'pactl' if client is built, with all symlinks except for
	# 'pulseaudio', 'pacmd' and 'pasuspender' which are installed if server is built.
	# This trips QA warning, workaround:
	# - install missing aliases in media-libs/libpulse (client build)
	# - remove corresponding symlinks in media-sound/pulseaudio-daemonclient (server build)
	bashcomp_alias pactl pulseaudio
	bashcomp_alias pactl pacmd
	bashcomp_alias pactl pasuspender

	if multilib_is_native_abi; then
		if use doc; then
			einfo "Installing documentation ..."
			docinto html
			dodoc -r doxygen/html/.
		fi
	fi
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" \( -name '*.a' -o -name '*.la' \) -delete || die
}

pkg_postinst() {
	optfeature_header "PulseAudio can be enhanced by installing the following:"
	use dbus && optfeature "restricted realtime capabilities via D-Bus" sys-auth/rtkit
}
