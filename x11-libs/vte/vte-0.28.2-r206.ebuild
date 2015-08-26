# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2 python-r1

DESCRIPTION="GNOME terminal widget"
HOMEPAGE="https://live.gnome.org/VTE"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE="debug glade +introspection python"

PDEPEND="x11-libs/gnome-pty-helper"
RDEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-2.20:2[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses:0=
	x11-libs/libX11
	x11-libs/libXft

	glade? ( dev-util/glade:3 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0 )
	python? (
		${PYTHON_DEPS}
		dev-python/pygtk:2[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	# Do not disable gnome-pty-helper, bug #401389
	G2CONF="${G2CONF}
		--disable-deprecation
		--disable-static
		$(use_enable debug)
		$(use_enable glade glade-catalogue)
		$(use_enable introspection)
		--with-gtk=2.0"

	if [[ ${CHOST} == *-interix* ]]; then
		G2CONF="${G2CONF} --disable-Bsymbolic"

		# interix stropts.h is empty...
		export ac_cv_header_stropts_h=no
	fi

	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# https://bugzilla.gnome.org/show_bug.cgi?id=663779
	epatch "${FILESDIR}/${PN}-0.30.1-alt-meta.patch"

	# https://bugzilla.gnome.org/show_bug.cgi?id=652290
	epatch "${FILESDIR}"/${PN}-0.28.2-interix.patch

	# Fix CVE-2012-2738, upstream bug #676090
	epatch "${FILESDIR}"/${PN}-0.28.2-limit-arguments.patch

	prepare_python() {
		mkdir -p "${BUILD_DIR}" || die
	}
	if use python; then
		python_foreach_impl prepare_python
	fi

	gnome2_src_prepare
}

src_configure() {
	configure_python() {
		ECONF_SOURCE="${S}" gnome2_src_configure --enable-python
	}

	if use python; then
		python_foreach_impl run_in_build_dir configure_python
	fi

	gnome2_src_configure --disable-python
}

src_compile() {
	gnome2_src_compile

	compile_python() {
		cd "${BUILD_DIR}"/python || die
		ln -s "${S}"/src/libvte.la "${BUILD_DIR}"/src/ || die
		mkdir -p "${BUILD_DIR}"/src/.libs || die
		ln -s "${S}"/src/.libs/libvte.so "${BUILD_DIR}"/src/.libs/ || die
		emake CPPFLAGS="${CPPFLAGS} -I${S}/src"
	}

	if use python; then
		python_foreach_impl run_in_build_dir compile_python
	fi
}

src_install() {
	gnome2_src_install

	install_python() {
		cd "${BUILD_DIR}"/python || die
		emake install DESTDIR="${D}" \
			CPPFLAGS="${CPPFLAGS} -I${S}/src"
	}
	if use python; then
		python_foreach_impl run_in_build_dir install_python
	fi

	rm -v "${ED}usr/libexec/gnome-pty-helper" || die
}
