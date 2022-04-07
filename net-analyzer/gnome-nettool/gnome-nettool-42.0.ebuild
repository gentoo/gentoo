# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit gnome.org meson python-any-r1

DESCRIPTION="Graphical front-ends to various networking command-line"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-nettool"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

COMMON_DEPEND="
	>=x11-libs/gtk+-3.0.0:3
	>=dev-libs/glib-2.26:2
	gnome-base/libgtop:2=
"
RDEPEND="${COMMON_DEPEND}
	|| (
		net-misc/iputils
		net-analyzer/tcptraceroute
		net-analyzer/traceroute
	)
	net-analyzer/nmap
	net-dns/bind-tools
	net-misc/netkit-fingerd
	net-misc/whois
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	virtual/pkgconfig
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}"/${PV}-meson-drop-unused-positional-arguments.patch
)
