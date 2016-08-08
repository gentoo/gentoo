# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit eutils git-r3 python-any-r1 autotools

DESCRIPTION="SPICE server"
HOMEPAGE="http://spice-space.org/"
SRC_URI=""
EGIT_REPO_URI="git://git.freedesktop.org/git/spice/spice"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="libressl lz4 sasl smartcard static-libs"

RDEPEND="
	>=dev-libs/glib-2.22:2[static-libs(+)?]
	>=media-libs/celt-0.5.1.1:0.5.1[static-libs(+)?]
	media-libs/opus[static-libs(+)?]
	sys-libs/zlib[static-libs(+)?]
	virtual/jpeg:0=[static-libs(+)?]
	>=x11-libs/pixman-0.17.7[static-libs(+)?]
	!libressl? ( dev-libs/openssl:0[static-libs(+)?] )
	libressl? ( dev-libs/libressl[static-libs(+)?] )
	lz4? ( app-arch/lz4 )
	smartcard? ( >=app-emulation/libcacard-0.1.2 )
	sasl? ( dev-libs/cyrus-sasl[static-libs(+)?] )"

DEPEND="
	=app-emulation/spice-protocol-9999
	virtual/pkgconfig
	$(python_gen_any_dep '
		>=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	')
	smartcard? ( app-emulation/qemu[smartcard] )
	${RDEPEND}"

# Prevent sandbox violations, bug #586560
# https://bugzilla.gnome.org/show_bug.cgi?id=581836
addpredict /dev

python_check_deps() {
	has_version ">=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]"
	has_version "dev-python/six[${PYTHON_USEDEP}]"
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && python-any-r1_pkg_setup
}

src_prepare() {
	epatch_user

	eautoreconf
	default
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable lz4) \
		$(use_with sasl) \
		$(use_enable smartcard) \
		--disable-gui
}

src_install() {
	default
	use static-libs || prune_libtool_files
}
