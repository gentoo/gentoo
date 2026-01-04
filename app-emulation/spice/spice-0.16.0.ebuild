# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit meson python-any-r1 readme.gentoo-r1 xdg-utils

DESCRIPTION="SPICE server"
HOMEPAGE="https://www.spice-space.org/"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/spice/spice.git"
	inherit git-r3

	DEPEND="~app-emulation/spice-protocol-9999"
else
	SRC_URI="https://www.spice-space.org/download/releases/spice-server/${P}.tar.bz2"
	KEYWORDS="~amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="gstreamer lz4 opus sasl smartcard static-libs test"
RESTRICT="!test? ( test )"

# The libspice-server only uses the headers of libcacard
RDEPEND="
	dev-lang/orc[static-libs(+)?]
	>=dev-libs/glib-2.38:2[static-libs(+)?]
	dev-libs/openssl:0=[static-libs(+)?]
	media-libs/opus[static-libs(+)?]
	media-libs/libjpeg-turbo:0=[static-libs(+)?]
	virtual/zlib:=[static-libs(+)?]
	>=x11-libs/pixman-0.17.7[static-libs(+)?]
	virtual/libudev
	lz4? ( app-arch/lz4:0=[static-libs(+)?] )
	opus? ( media-libs/opus[static-libs(+)?] )
	smartcard? ( >=app-emulation/libcacard-2.5.1 )
	sasl? ( dev-libs/cyrus-sasl[static-libs(+)?] )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
"
DEPEND+="
	${RDEPEND}
	>=app-emulation/spice-protocol-0.14.5
	smartcard? ( app-emulation/qemu[smartcard] )
	test? ( net-libs/glib-networking )
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/glib-utils
	virtual/pkgconfig
	$(python_gen_any_dep '
		>=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]
	')
"

python_check_deps() {
	python_has_version -b ">=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]"
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && python-any-r1_pkg_setup
}

PATCHES=(
	"${FILESDIR}/${P}-c++20-adjust-designated-init.patch"
)

src_configure() {
	# Prevent sandbox violations, bug #586560
	# https://bugzilla.gnome.org/show_bug.cgi?id=744134
	# https://bugzilla.gnome.org/show_bug.cgi?id=744135
	use gstreamer && addpredict /dev

	xdg_environment_reset

	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		-Dgstreamer=$(usex gstreamer 1.0 no)
		-Dopus=enabled
		-Dmanual=false
		$(meson_use lz4)
		$(meson_use sasl)
		$(meson_feature opus)
		$(meson_feature smartcard)
		$(meson_use test tests)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
