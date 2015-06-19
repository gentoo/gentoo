# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-trayicons/gkrellm-trayicons-1.03.ebuild,v 1.10 2010/07/22 14:39:25 ssuominen Exp $

inherit gkrellm-plugin

DESCRIPTION="Configurable Tray Icons for GKrellM"
HOMEPAGE="http://tripie.sweb.cz/gkrellm/trayicons/"
SRC_URI="http://tripie.sweb.cz/gkrellm/trayicons/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

PLUGIN_SO=trayicons.so
