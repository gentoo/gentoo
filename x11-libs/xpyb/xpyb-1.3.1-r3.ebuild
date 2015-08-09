# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_AUTORECONF=1

inherit flag-o-matic xorg-2 python-r1

#EGIT_REPO_URI="git://anongit.freedesktop.org/git/xcb/xpyb"
SRC_URI="http://xcb.freedesktop.org/dist/${P}.tar.bz2"
DESCRIPTION="XCB-based Python bindings for the X Window System"
HOMEPAGE="http://xcb.freedesktop.org/"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="selinux"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=x11-libs/libxcb-1.7
	>=x11-proto/xcb-proto-1.7.1[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-python.patch
	"${FILESDIR}"/${PN}-1.3.1-xcbproto-1.9.patch
)
DOCS=( NEWS README )

pkg_setup() {
	xorg-2_pkg_setup
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable selinux)
	)
}

src_configure() {
	append-cflags -fno-strict-aliasing
	python_foreach_impl xorg-2_src_configure
}

src_compile() {
	python_foreach_impl xorg-2_src_compile
}

src_install() {
	python_foreach_impl xorg-2_src_install
}
