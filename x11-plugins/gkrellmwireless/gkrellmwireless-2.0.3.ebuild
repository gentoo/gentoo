# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellmwireless/gkrellmwireless-2.0.3.ebuild,v 1.12 2010/03/12 00:44:51 sping Exp $

inherit gkrellm-plugin

IUSE=""
S="${WORKDIR}/${PN}"
DESCRIPTION="A plugin for GKrellM that monitors your wireless network card"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/gkrellmwireless.php"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~sparc x86"

PLUGIN_SO=wireless.so
