# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/i8krellm/i8krellm-2.5.ebuild,v 1.10 2010/07/22 14:28:16 ssuominen Exp $

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
