# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE="gst-plugins-ugly"
PYTHON_COMPAT=( python3_{8,9,10} )
inherit gstreamer-meson python-any-r1

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2+" # some split plugins are LGPL but combining with a GPL library
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc x86"

IUSE="+orc"

RDEPEND="
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

DOCS=( AUTHORS ChangeLog NEWS README.md RELEASE )

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
