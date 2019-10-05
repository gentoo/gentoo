# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )
PYTHON_REQ_USE='threads(+)' # required by waf

inherit python-any-r1 vala waf-utils

DESCRIPTION="Simple ALSA volume control for xfce4-panel"
HOMEPAGE="https://github.com/equeim/xfce4-alsa-plugin"
SRC_URI="https://github.com/equeim/${PN}/archive/0.1.1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

RDEPEND="
	media-libs/alsa-lib
	xfce-base/xfce4-panel[gtk2(+)]
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	dev-util/intltool
"

pkg_setup() { python-any-r1_pkg_setup; }

src_prepare() {
	vala_src_prepare --ignore-use
	eapply_user
}
