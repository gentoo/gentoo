# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit autotools ltprune python-any-r1 readme.gentoo-r1 xdg-utils

DESCRIPTION="SPICE server"
HOMEPAGE="https://www.spice-space.org/"
SRC_URI="https://www.spice-space.org/download/releases/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="libressl lz4 sasl smartcard static-libs gstreamer"

# the libspice-server only uses the headers of libcacard
RDEPEND="
	dev-lang/orc[static-libs(+)?]
	>=dev-libs/glib-2.22:2[static-libs(+)?]
	media-libs/opus[static-libs(+)?]
	sys-libs/zlib[static-libs(+)?]
	virtual/jpeg:0=[static-libs(+)?]
	>=x11-libs/pixman-0.17.7[static-libs(+)?]
	!libressl? ( dev-libs/openssl:0=[static-libs(+)?] )
	libressl? ( dev-libs/libressl:0=[static-libs(+)?] )
	lz4? ( app-arch/lz4:0=[static-libs(+)?] )
	smartcard? ( >=app-emulation/libcacard-0.1.2 )
	sasl? ( dev-libs/cyrus-sasl[static-libs(+)?] )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=app-emulation/spice-protocol-0.12.13
	virtual/pkgconfig
	$(python_gen_any_dep '
		>=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	')
	smartcard? ( app-emulation/qemu[smartcard] )"

PATCHES=(
	"${FILESDIR}"/${P}-libressl_fix.patch
	"${FILESDIR}"/${P}-openssl1.1_fix.patch
)

python_check_deps() {
	has_version ">=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]"
	has_version "dev-python/six[${PYTHON_USEDEP}]"
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && python-any-r1_pkg_setup
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# Prevent sandbox violations, bug #586560
	# https://bugzilla.gnome.org/show_bug.cgi?id=744134
	# https://bugzilla.gnome.org/show_bug.cgi?id=744135
	addpredict /dev

	xdg_environment_reset

	local myconf="
		$(use_enable static-libs static)
		$(use_enable lz4)
		$(use_with sasl)
		$(use_enable smartcard)
		--enable-gstreamer=$(usex gstreamer "1.0" "no")
		--disable-celt051
		"
	econf ${myconf}
}

src_compile() {
	# Prevent sandbox violations, bug #586560
	# https://bugzilla.gnome.org/show_bug.cgi?id=744134
	# https://bugzilla.gnome.org/show_bug.cgi?id=744135
	addpredict /dev

	default
}

src_install() {
	default
	use static-libs || prune_libtool_files
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
