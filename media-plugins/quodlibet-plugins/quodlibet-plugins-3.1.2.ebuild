# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/quodlibet-plugins/quodlibet-plugins-3.1.2.ebuild,v 1.5 2015/06/11 14:26:29 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-r1

DESCRIPTION="Plugins for Quod Libet and Ex Falso"
HOMEPAGE="http://code.google.com/p/quodlibet/"
SRC_URI="http://bitbucket.org/lazka/quodlibet-files/raw/default/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=media-sound/quodlibet-${PV}"
DEPEND=""

src_prepare() {
	rm -f README || die
}

src_install() {
	local python_moduleroot=quodlibet/plugins
	python_foreach_impl python_domodule .
}
