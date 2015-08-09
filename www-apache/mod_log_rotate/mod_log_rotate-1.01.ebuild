# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit apache-module

DESCRIPTION="Log rotation support for mod_log_config based on strftime(3)"
HOMEPAGE="https://github.com/JBlond/${PN}"
SRC_URI="https://github.com/JBlond/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="LOG_ROTATE"
DOCFILES="README.md"

need_apache2
