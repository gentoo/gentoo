# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 webapp

DESCRIPTION="Lightweight weblog system"
HOMEPAGE="http://pyblosxom.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~x86"

# This installs python library files.
SLOT=0
WEBAPP_MANUAL_SLOT=yes

IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-1.4.2-gentoo.patch"
)

src_install() {
	webapp_src_preinst

	distutils-r1_src_install

	keepdir /usr/share/${P}/plugins
	keepdir "${MY_HTDOCSDIR}"/data
	keepdir "${MY_HTDOCSDIR}"/log

	insinto "${MY_CGIBINDIR}"/pyblosxom
	doins web/{config.py,pyblosxom.cgi}

	webapp_configfile "${MY_CGIBINDIR}"/pyblosxom/config.py

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_postupgrade_txt en "${FILESDIR}"/postupgrade-en.txt
	webapp_hook_script "${FILESDIR}"/config-hook.sh

	webapp_src_install
}
