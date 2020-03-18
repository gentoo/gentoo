# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7} )

inherit eutils git-r3 meson python-any-r1 readme.gentoo-r1 xdg-utils

DESCRIPTION="SPICE server"
HOMEPAGE="https://www.spice-space.org/"
SRC_URI=""
EGIT_REPO_URI="https://anongit.freedesktop.org/git/spice/spice.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="libressl lz4 sasl smartcard gstreamer"

# the libspice-server only uses the headers of libcacard
RDEPEND="
	dev-lang/orc
	>=dev-libs/glib-2.22:2
	media-libs/opus
	sys-libs/zlib
	virtual/jpeg:0=
	>=x11-libs/pixman-0.17.7
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	lz4? ( app-arch/lz4:0= )
	smartcard? ( >=app-emulation/libcacard-0.1.2 )
	sasl? ( dev-libs/cyrus-sasl )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)"
DEPEND="${RDEPEND}
	~app-emulation/spice-protocol-9999
	smartcard? ( app-emulation/qemu[smartcard] )"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
	$(python_gen_any_dep '
		>=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	')"

python_check_deps() {
	has_version -b ">=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]"
	has_version -b "dev-python/six[${PYTHON_USEDEP}]"
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && python-any-r1_pkg_setup
}

src_configure() {
	# Prevent sandbox violations, bug #586560
	# https://bugzilla.gnome.org/show_bug.cgi?id=744134
	# https://bugzilla.gnome.org/show_bug.cgi?id=744135
	addpredict /dev

	xdg_environment_reset

	local emesonargs=(
		$(meson_use lz4)
		$(meson_use sasl)
		$(meson_feature smartcard)
		-Dgstreamer=$(usex gstreamer "1.0" "no")
		-Dcelt051=disabled
	)
	meson_src_configure
}

src_compile() {
	# Prevent sandbox violations, bug #586560
	# https://bugzilla.gnome.org/show_bug.cgi?id=744134
	# https://bugzilla.gnome.org/show_bug.cgi?id=744135
	addpredict /dev

	meson_src_compile
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
