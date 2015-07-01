# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/thunarx-python/thunarx-python-0.3.0-r1.ebuild,v 1.4 2015/07/01 16:31:33 zlogene Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 xfconf

DESCRIPTION="Python bindings for the Thunar file manager"
HOMEPAGE="http://goodies.xfce.org/projects/bindings/thunarx-python"
SRC_URI="mirror://xfce/src/bindings/${PN}/0.3/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="${PYTHON_DEPS}
	x11-libs/gtk+:2
	dev-libs/glib:2
	>=dev-python/pygobject-2.16:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	>=xfce-base/thunar-1.1.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

pkg_setup() {
	XFCONF=(
		--disable-dependency-tracking
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )

	python-single-r1_pkg_setup
}

src_install() {
	xfconf_src_install \
		docsdir=/usr/share/doc/${PF} \
		examplesdir=/usr/share/doc/${PF}/examples
}
