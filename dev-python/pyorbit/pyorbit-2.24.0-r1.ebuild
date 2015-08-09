# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 multilib python-r1

DESCRIPTION="ORBit2 bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	>=gnome-base/orbit-2.12"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"

src_prepare() {
	gnome2_src_prepare
	python_copy_sources
}

src_configure() {
	python_parallel_foreach_impl run_in_build_dir gnome2_src_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_test() {
	python_foreach_impl run_in_build_dir default_src_test
}

src_install() {
	python_foreach_impl run_in_build_dir gnome2_src_install
}
