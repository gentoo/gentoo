# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit gnome2 python-r1 vala

DESCRIPTION="VNC viewer widget for GTK"
HOMEPAGE="https://wiki.gnome.org/Projects/gtk-vnc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="examples +gtk3 +introspection pulseaudio python sasl vala"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	vala? ( gtk3 introspection )
"

# libview is used in examples/gvncviewer -- no need
# glib-2.30.1 needed to avoid linking failure due to .la files (bug #399129)
COMMON_DEPEND="
	>=dev-libs/glib-2.30.1:2
	>=dev-libs/libgcrypt-1.4.2:0=
	dev-libs/libgpg-error
	>=net-libs/gnutls-2.12
	>=x11-libs/cairo-1.2
	>=x11-libs/gtk+-2.18:2
	x11-libs/libX11
	gtk3? ( >=x11-libs/gtk+-2.91.3:3 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.4 )
	pulseaudio? ( media-sound/pulseaudio )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygtk-2:2[${PYTHON_USEDEP}] )
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

GTK2_BUILDDIR="${WORKDIR}/${P}_gtk2"
GTK3_BUILDDIR="${WORKDIR}/${P}_gtk3"

src_prepare() {
	mkdir -p "${GTK2_BUILDDIR}" || die
	mkdir -p "${GTK3_BUILDDIR}" || die
	prepare_python() {
		mkdir -p "${BUILD_DIR}" || die
	}
	if use python; then
		python_foreach_impl prepare_python
	fi

	# Fix incorrect codegendir check: h2def.py is in pygobject, not pygtk, upstream bug#744393
	sed -e 's/codegendir pygtk-2.0/codegendir pygobject-2.0/g' \
		-i src/Makefile.* || die

	# libtool seems unable to find this via VPATH so help it
	sed -r "s:(gtkvnc_la_LIBADD =) libgtk-vnc-.*\.la:\1 ${GTK2_BUILDDIR}/src/libgtk-vnc-1.0.la:" \
		-i src/Makefile.{am,in} || die

	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local myconf
	myconf="
		$(use_with examples) \
		$(use_enable introspection) \
		$(use_with pulseaudio) \
		$(use_with sasl) \
		--with-coroutine=gthread \
		--without-libview \
		--disable-static \
		--disable-vala"

	cd "${GTK2_BUILDDIR}" || die
	einfo "Running configure in ${GTK2_BUILDDIR}"
	ECONF_SOURCE="${S}" gnome2_src_configure ${myconf} \
		--with-python=no \
		--with-gtk=2.0

	configure_python() {
		ECONF_SOURCE="${S}" gnome2_src_configure ${myconf} \
			$(use_with python) \
			--with-gtk=2.0
	}
	if use python; then
		python_foreach_impl run_in_build_dir configure_python
	fi

	if use gtk3; then
		cd "${GTK3_BUILDDIR}" || die
		einfo "Running configure in ${GTK3_BUILDDIR}"
		# Python support is via gobject-introspection
		# Ex: from gi.repository import GtkVnc
		ECONF_SOURCE="${S}" gnome2_src_configure ${myconf} \
			$(use_enable vala) \
			--with-python=no \
			--with-gtk=3.0
	fi
}

src_compile() {
	cd "${GTK2_BUILDDIR}" || die
	einfo "Running make in ${GTK2_BUILDDIR}"
	gnome2_src_compile

	compile_python() {
		cd "${BUILD_DIR}"/src || die
		# CPPFLAGS set to help find includes for gvnc.override
		emake gtkvnc.la \
			VPATH="${S}/src:${GTK2_BUILDDIR}/src:${BUILD_DIR}/src" \
			CPPFLAGS="${CPPFLAGS} -I${GTK2_BUILDDIR}/src"
	}
	if use python; then
		python_foreach_impl run_in_build_dir compile_python
	fi

	if use gtk3; then
		cd "${GTK3_BUILDDIR}" || die
		einfo "Running make in ${GTK3_BUILDDIR}"
		gnome2_src_compile
	fi
}

src_test() {
	cd "${GTK2_BUILDDIR}" || die
	einfo "Running make check in ${GTK2_BUILDDIR}"
	default

	if use gtk3; then
		cd "${GTK3_BUILDDIR}" || die
		einfo "Running make check in ${GTK3_BUILDDIR}"
		default
	fi
}

src_install() {
	cd "${GTK2_BUILDDIR}" || die
	einfo "Running make install in ${GTK2_BUILDDIR}"
	gnome2_src_install

	install_python() {
		cd "${BUILD_DIR}"/src || die
		emake install-pyexecLTLIBRARIES DESTDIR="${D}" \
			VPATH="${S}/src:${GTK2_BUILDDIR}/src:${BUILD_DIR}/src" \
			CPPFLAGS="${CPPFLAGS} -I${GTK2_BUILDDIR}/src"
	}
	if use python; then
		python_foreach_impl run_in_build_dir install_python
	fi

	if use gtk3; then
		cd "${GTK3_BUILDDIR}" || die
		einfo "Running make install in ${GTK3_BUILDDIR}"
		gnome2_src_install
	fi
}
