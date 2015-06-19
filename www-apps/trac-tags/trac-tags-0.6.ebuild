# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/trac-tags/trac-tags-0.6.ebuild,v 1.3 2014/08/10 20:15:43 slyfox Exp $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_REV="9901"
MY_DIR="tagsplugin/tags/${PV}"

DESCRIPTION="Tags plugin for Trac"
HOMEPAGE="http://trac-hacks.org/wiki/TagsPlugin"
SRC_URI="http://trac-hacks.org/changeset/${MY_REV}/${MY_DIR}?old_path=%2F&format=zip
	-> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND=">=dev-python/genshi-0.6"
DEPEND="${CDEPEND}
	dev-python/setuptools
	app-arch/unzip"
RDEPEND="${CDEPEND}
	>=www-apps/trac-0.11"

S="${WORKDIR}/${MY_DIR}"
