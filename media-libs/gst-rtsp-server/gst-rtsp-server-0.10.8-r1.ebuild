# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-rtsp-server/gst-rtsp-server-0.10.8-r1.ebuild,v 1.4 2015/03/15 13:35:49 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils gstreamer python-r1 vala

DESCRIPTION="A GStreamer based RTSP server"
HOMEPAGE="http://people.freedesktop.org/~wtay/"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${PN/-server/}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0.10"
KEYWORDS="amd64 x86"
IUSE="examples +introspection nls python static-libs test vala"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${P/-server/}"

# ./configure is broken, so PYGOBJECT_REQ must be defined
PYGOBJECT_REQ=2.11.2

# FIXME: check should depend on USE=test but check is losy
# libxml2 required in python binding
RDEPEND="
	>=dev-libs/glib-2.10.0:2[${MULTILIB_USEDEP}]
	dev-libs/libxml2:2[python,${PYTHON_USEDEP},${MULTILIB_USEDEP}]
	>=dev-python/pygobject-${PYGOBJECT_REQ}:2[${PYTHON_USEDEP}]
	>=media-libs/gstreamer-0.10.29:0.10[introspection?,${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-0.10.29:0.10[introspection?,${MULTILIB_USEDEP}]

	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )
	python? ( dev-python/gst-python:0.10[${PYTHON_USEDEP}] )
	vala? ( $(vala_depend) )
"
DEPEND="${RDEPEND}
	>=dev-libs/check-0.9.2
	>=dev-util/gtk-doc-am-1.3
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.17 )
"

# Does not provide any unittest
RESTRICT="test"

src_prepare() {
	if ! use test; then
		# don't waste time building tests
		sed -e 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' \
			-i Makefile.am Makefile.in \
			|| die
	fi

	# don't waste time building examples
	sed -e 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
		 -i Makefile.am Makefile.in \
		|| die

	use vala && vala_src_prepare
}

multilib_src_configure() {
	if use python ; then
		python_setup
	fi

	# debug: only adds -g to CFLAGS
	# docbook: nothing behing that switch
	gstreamer_multilib_src_configure \
		--disable-docbook \
		--disable-gtk-doc \
		$(multilib_native_use_enable introspection) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_enable vala) \
		PYTHON=$(multilib_native_usex python "${PYTHON}" false) \
		PYGOBJECT_REQ=${PYGOBJECT_REQ}

	# work-around gtk-doc out-of-source brokedness
	if multilib_is_native_abi ; then
		ln -s "${S}"/docs/libs/${d}/html docs/libs/${d}/html || die
	fi
}

multilib_src_install() {
	emake install DESTDIR="${D}"
	# Handle broken upstream modifications to defaults of gtk-doc
	emake install -C docs/libs DESTDIR="${D}"
	prune_libtool_files
}

multilib_src_install_all() {
	einstalldocs

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins "${S}"/examples/*.c
	fi
}
