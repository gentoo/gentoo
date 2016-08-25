# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils multilib

DESCRIPTION="A synchronization engine for SynCE"
HOMEPAGE="https://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-pda/synce-core[python]
	>=dev-libs/librra-0.16[python]
	>=dev-libs/librtfcomp-1.2[python]
	dev-libs/libxml2[python]
	dev-libs/libxslt[python]
	dev-python/dbus-python
	dev-python/pygobject:2"
DEPEND=${RDEPEND}

PYTHON_MODNAME=SyncEngine

src_prepare() {
	sed -i -e 's:share/doc/sync-engine:foobar:' setup.py || die

	distutils_src_prepare
}

src_install() {
	insinto /usr/share/dbus-1/services
	doins config/org.synce.SyncEngine.service || die

	insinto /etc
	doins config/syncengine.conf.xml || die

	distutils_src_install

	rm -rf "${ED}"/usr/foobar
}
