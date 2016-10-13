# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MATE_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit mate python-single-r1

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="Python bindings for the Caja file manager"
LICENSE="GPL-2"
SLOT="0"

IUSE="doc gtk3"

RDEPEND="dev-libs/glib:2
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=mate-base/caja-1.8[gtk3(-)=,introspection]
	!gtk3? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	virtual/pkgconfig:*
	doc? ( app-text/docbook-xml-dtd:4.1.2 )"

src_install() {
	mate_src_install

	# Keep the directory for systemwide extensions.
	keepdir /usr/share/python-caja/extensions/

	# The HTML documentation generation is broken and commented out by upstream.
	#
	#if use doc ; then
	#	insinto /usr/share/gtk-doc/html/nautilus-python # for dev-util/devhelp
	#	doins -r docs/html/*
	#fi
}
