# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/dcaenc/dcaenc-2.ebuild,v 1.1 2014/08/22 17:50:07 beandog Exp $

EAPI=5

DESCRIPTION="DTS Coherent Acoustics audio encoder"
HOMEPAGE="http://aepatrakov.narod.ru/index/0-2"
SRC_URI="http://aepatrakov.narod.ru/olderfiles/1/${P}.tar.gz"
LICENSE="LGPL-2.1+"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa"

DEPEND="alsa? ( media-libs/alsa-lib )"
