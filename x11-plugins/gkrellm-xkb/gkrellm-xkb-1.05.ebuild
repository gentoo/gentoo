# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-xkb/gkrellm-xkb-1.05.ebuild,v 1.7 2009/02/19 03:03:56 wormo Exp $

inherit gkrellm-plugin

DESCRIPTION="XKB keyboard switcher for gkrellm2"
HOMEPAGE="http://tripie.sweb.cz/gkrellm/xkb/"
SRC_URI="http://tripie.sweb.cz/gkrellm/xkb/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

PLUGIN_SO=xkb.so
