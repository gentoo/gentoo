# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgit2-glib/libgit2-glib-0.22.0.ebuild,v 1.3 2015/07/26 02:27:25 tetromino Exp $

EAPI=5

GCONF_DEBUG="no"
PYTHON_COMPAT=( python{3_3,3_4} )
VALA_MIN_API_VERSION="0.22"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils gnome2 python-r1 vala

DESCRIPTION="Git library for GLib"
HOMEPAGE="https://wiki.gnome.org/Projects/Libgit2-glib"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python ssh +vala"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/libgit2-0.21.0:=
	<dev-libs/libgit2-0.23
	>=dev-libs/glib-2.28.0:2
	>=dev-libs/gobject-introspection-0.10.1
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}] )
	ssh? ( dev-libs/libgit2[ssh] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.11
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	# Make libgit2[ssh] dep non-magic, upstream bug #743236
	epatch "${FILESDIR}/${PN}-0.22.0-automagic-ssh.patch"

	eautoreconf
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable python) \
		$(use_enable ssh) \
		$(use_enable vala)
}
