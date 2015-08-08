# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"
DISTUTILS_SINGLE_IMPL=1

inherit eutils distutils-r1 webapp

MY_PN="moin"

DESCRIPTION="Python WikiClone"
HOMEPAGE="http://moinmo.in/"
SRC_URI="http://static.moinmo.in/files/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"

RDEPEND=">=dev-python/docutils-0.4[${PYTHON_USEDEP}]
	>=dev-python/flup-1.0.2[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.7.0[${PYTHON_USEDEP}]"

need_httpd_cgi

S=${WORKDIR}/${MY_PN}-${PV}

WEBAPP_MANUAL_SLOT="yes"

pkg_setup() {
	if has_version "<www-apps/moinmoin-1.9" ; then
		ewarn
		ewarn "You already have a version of moinmoin prior to 1.9 installed."
		ewarn "moinmoin-1.9 has a very different configuration than 1.8 (among"
		ewarn "other changes, static content is no longer installed under the"
		ewarn "htdocs directory)."
		ewarn
		ewarn "Please read http://moinmo.in/MoinMoinRelease1.9 and"
		ewarn "README.migration in /usr/share/doc/${PF}"
		ewarn
	fi

	webapp_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	# remove bundled -- parsedatetime and xappy not packaged yet
	rm -r MoinMoin/support/{pygments,werkzeug,flup} || die
	sed -i "/\(flup\|pygments\|werkzeug\)/d" setup.py || die

	# needed for python_fix_shebang
	edos2unix MoinMoin/web/static/htdocs/applets/FCKeditor/editor/filemanager/connectors/py/*.py

	distutils-r1_src_prepare
}

src_install() {
	webapp_src_preinst
	distutils-r1_src_install

	dodoc README docs/CHANGES* docs/README.migration
	dohtml docs/INSTALL.html
	rm -rf README docs/

	cd "${D}"/usr/share/moin

	insinto "${MY_HTDOCSDIR}"
	doins -r server/moin.cgi
	fperms +x "${MY_HTDOCSDIR}/moin.cgi"

	insinto "${MY_HOSTROOTDIR}"/${PF}
	doins -r data underlay config/wikiconfig.py

	insinto "${MY_HOSTROOTDIR}"/${PF}/altconfigs
	doins -r config

	insinto "${MY_HOSTROOTDIR}"/${PF}/altserver
	doins -r server

	# data needs to be server owned per moin devs
	cd "${D}/${MY_HOSTROOTDIR}"/${PF}
	for file in $(find data underlay); do
		webapp_serverowned "${MY_HOSTROOTDIR}/${PF}/${file}"
	done

	webapp_configfile "${MY_HOSTROOTDIR}"/${PF}/wikiconfig.py
	webapp_hook_script "${FILESDIR}"/reconfig-1.9.4
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-1.9.4.txt

	webapp_src_install

	# bug 466390
	python_fix_shebang "${D}"
}

pkg_postinst() {
	ewarn
	ewarn "If you are upgrading from an older version, please read"
	ewarn "README.migration in /usr/share/doc/${PF}"
	ewarn

	distutils_pkg_postinst
	webapp_pkg_postinst
}
