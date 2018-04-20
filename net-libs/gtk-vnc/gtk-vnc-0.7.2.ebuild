# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit gnome2 multibuild vala

DESCRIPTION="VNC viewer widget for GTK"
HOMEPAGE="https://wiki.gnome.org/Projects/gtk-vnc"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="examples +gtk3 +introspection pulseaudio sasl vala"
REQUIRED_USE="
	vala? ( gtk3 introspection )
"

# libview is used in examples/gvncviewer -- no need
# glib-2.30.1 needed to avoid linking failure due to .la files (bug #399129)
COMMON_DEPEND="
	>=dev-libs/glib-2.30.1:2
	>=dev-libs/libgcrypt-1.4.2:0=
	dev-libs/libgpg-error
	>=net-libs/gnutls-3.0:0=
	>=x11-libs/cairo-1.2
	>=x11-libs/gtk+-2.18:2
	x11-libs/libX11
	gtk3? ( >=x11-libs/gtk+-2.91.3:3[introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.4:= )
	pulseaudio? ( media-sound/pulseaudio )
	sasl? ( dev-libs/cyrus-sasl )
"
RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	vala? (
		$(vala_depend)
		>=dev-libs/gobject-introspection-0.9.4 )
"
# eautoreconf requires gnome-common

compute_variants() {
	MULTIBUILD_VARIANTS=( 2.0 )
	use gtk3 && MULTIBUILD_VARIANTS+=( 3.0 )
}

src_prepare() {
	prepare() {
		mkdir -p "${BUILD_DIR}" || die
	}

	local MULTIBUILD_VARIANTS
	compute_variants
	multibuild_foreach_variant prepare

	# Fix incorrect codegendir check: h2def.py is in pygobject, not pygtk, upstream bug#744393
	sed -e 's/codegendir pygtk-2.0/codegendir pygobject-2.0/g' \
		-i src/Makefile.* || die

	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local myconf=(
		$(use_with examples)
		$(use_enable introspection)
		$(use_with pulseaudio)
		$(use_with sasl)
		--with-coroutine=gthread
		--without-libview
		--disable-static
		--disable-vala
	)

	configure_normal() {
		ECONF_SOURCE="${S}" gnome2_src_configure \
			${myconf[@]} \
			--with-gtk=${MULTIBUILD_VARIANT} \
			--without-python
	}

	local MULTIBUILD_VARIANTS
	compute_variants
	multibuild_foreach_variant run_in_build_dir configure_normal
}

src_compile() {
	compile_normal() {
		gnome2_src_compile
	}

	local MULTIBUILD_VARIANTS
	compute_variants
	multibuild_foreach_variant run_in_build_dir compile_normal
}

src_test() {
	local MULTIBUILD_VARIANTS
	compute_variants

	multibuild_foreach_variant run_in_build_dir default
}

src_install() {
	install_normal() {
		gnome2_src_install
	}

	local MULTIBUILD_VARIANTS
	compute_variants
	multibuild_foreach_variant run_in_build_dir install_normal
}
