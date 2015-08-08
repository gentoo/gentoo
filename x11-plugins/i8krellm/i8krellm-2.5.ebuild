# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gkrellm-plugin

DESCRIPTION="GKrellM2 Plugin for the Dell Inspiron and Latitude notebooks"
SRC_URI="http://www.coding-zone.com/${P}.tar.gz"
HOMEPAGE="http://www.coding-zone.com/?page=i8krellm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 -ppc -sparc -alpha -mips -hppa"
IUSE=""

RDEPEND=">=app-laptop/i8kutils-1.5"
DEPEND="${RDEPEND}"
