# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta ebuild to pull in opencpn plugins"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=sci-geosciences/opencpn-${PV}
	>=sci-geosciences/opencpn-plugin-dr-1.1
	>=sci-geosciences/opencpn-plugin-findit-1.1007
	>=sci-geosciences/opencpn-plugin-gxradar-1.1
	>=sci-geosciences/opencpn-plugin-iacfleet-0.8
	>=sci-geosciences/opencpn-plugin-launcher-1.1
	>=sci-geosciences/opencpn-plugin-logbookkonni-1.3002
	>=sci-geosciences/opencpn-plugin-objsearch-0.7
	>=sci-geosciences/opencpn-plugin-ocpn_draw-1.0.12
	>=sci-geosciences/opencpn-plugin-ocpndebugger-1.2
	>=sci-geosciences/opencpn-plugin-oesenc-1.6.0
	>=sci-geosciences/opencpn-plugin-otcurrent-1.2
	>=sci-geosciences/opencpn-plugin-polar-1.1007
	>=sci-geosciences/opencpn-plugin-radar-0.98
	>=sci-geosciences/opencpn-plugin-route-1.2
	>=sci-geosciences/opencpn-plugin-squiddio-0.7
	>=sci-geosciences/opencpn-plugin-watchdog-1.9.051
	>=sci-geosciences/opencpn-plugin-weather_routing-1.10.1
	>=sci-geosciences/opencpn-plugin-climatology-1.0.20180316
	>=sci-geosciences/opencpn-plugin-statusbar-0.5.20180316
	>=sci-geosciences/opencpn-plugin-weatherfax-1.3.20180316
"
