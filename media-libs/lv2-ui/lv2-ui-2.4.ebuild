# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/lv2-ui/lv2-ui-2.4.ebuild,v 1.4 2015/01/03 15:00:17 mgorny Exp $

EAPI=3

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE='threads'

inherit python-any-r1 waf-utils

DESCRIPTION="Generic UI interface for LV2 plugins"
HOMEPAGE="http://lv2plug.in/ns/extensions/ui"
SRC_URI="http://lv2plug.in/spec/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND=">=media-libs/lv2core-6.0"

DOCS=( "NEWS" )
