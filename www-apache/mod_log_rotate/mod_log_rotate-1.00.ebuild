# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils apache-module

DESCRIPTION="mod_log_rotate adds log rotation support to mod_log_config based on strftime(3)"
HOMEPAGE="http://www.hexten.net/wiki/index.php/Mod-log-rotate"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="LOG_ROTATE"

need_apache2
