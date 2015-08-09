# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="emerge this package to install all of the gkrellm plugins"
HOMEPAGE="http://www.gkrellm.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc ~x86"
IUSE="wifi"

RDEPEND="!<app-admin/gkrellm-2
		>=x11-plugins/gkrellaclock-0.3.2
		x11-plugins/gkrellflynn
		>=x11-plugins/gkrellkam-2.0.0
		>=x11-plugins/gkrellm-leds-0.8.0
		>=x11-plugins/gkrellm-volume-2.1.4
		>=x11-plugins/gkrellmlaunch-0.5
		>=x11-plugins/gkrellmoon-0.6
		wifi? ( >=x11-plugins/gkrellmwireless-2.0.2 )
		>=x11-plugins/gkrellshoot-0.4.1
		>=x11-plugins/gkrellstock-0.5
		>=x11-plugins/gkrellsun-0.12.2
		x11-plugins/gkrelltop
		>=x11-plugins/gkrellweather-2.0.6
		x11-plugins/gkrellm-countdown
		x11-plugins/gkrellm-trayicons"
