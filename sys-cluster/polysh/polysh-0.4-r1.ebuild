# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/polysh/polysh-0.4-r1.ebuild,v 1.6 2015/04/08 18:25:45 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Aggregate several remote shells into one"
HOMEPAGE="http://guichaz.free.fr/polysh/"
SRC_URI="http://guichaz.free.fr/polysh/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""
