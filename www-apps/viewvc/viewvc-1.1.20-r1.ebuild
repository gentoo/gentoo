# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 webapp

WEBAPP_MANUAL_SLOT="yes"

DESCRIPTION="ViewVC, a web interface to CVS and Subversion"
HOMEPAGE="http://viewvc.org/"
DOWNLOAD_NUMBER="49275"
SRC_URI="http://viewvc.tigris.org/files/documents/3330/${DOWNLOAD_NUMBER}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="cvs cvsgraph mod_wsgi mysql pygments +subversion"

DEPEND=""
RDEPEND="${PYTHON_DEPS}
	cvs? ( dev-vcs/rcs )
	subversion? ( >=dev-vcs/subversion-1.3.1[python,${PYTHON_USEDEP}] )

	mod_wsgi? ( www-apache/mod_wsgi[${PYTHON_USEDEP}] )
	!mod_wsgi? ( virtual/httpd-cgi )

	cvsgraph? ( >=dev-vcs/cvsgraph-1.5.0 )
	mysql? ( >=dev-python/mysql-python-0.9.0[${PYTHON_USEDEP}] )
	pygments? (
		dev-python/pygments[${PYTHON_USEDEP}]
		app-misc/mime-types
	)
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( cvs subversion )"

pkg_setup() {
	python-single-r1_pkg_setup
	webapp_pkg_setup
}

src_prepare() {
	eapply_user

	find bin/ -type f -print0 | xargs -0 sed -i \
		-e "s|\(^LIBRARY_DIR\)\(.*\$\)|\1 = \"$(python_get_sitedir)/${PN}\"|g" \
		-e "s|\(^CONF_PATHNAME\)\(.*\$\)|\1 = \"../conf/viewvc.conf\"|g" || die

	sed -i -e "s|\(self\.options\.template_dir\)\(.*\$\)|\1 = \"${MY_APPDIR}/templates\"|" \
		lib/config.py || die

	sed -i -e "s|^template_dir.*|#&|" conf/viewvc.conf.dist || die
	sed -i -e "s|^#mime_types_files =.*|mime_types_files = /etc/mime.types|" conf/viewvc.conf.dist || die
	mv conf/viewvc.conf{.dist,} || die
	mv conf/cvsgraph.conf{.dist,} || die

	python_fix_shebang .
}

src_install() {
	webapp_src_preinst

	newbin bin/standalone.py viewvc-standalone-server

	dodoc CHANGES COMMITTERS INSTALL README

	python_moduleinto viewvc
	python_domodule lib/.

	insinto "${MY_APPDIR}"
	doins -r templates/ || die "doins failed"
	doins -r templates-contrib/

	if use mysql; then
		exeinto "${MY_HOSTROOTDIR}/bin"
		doexe bin/{*dbadmin,make-database,loginfo-handler}
	fi

	insinto "${MY_HOSTROOTDIR}/conf"
	doins conf/{viewvc,cvsgraph}.conf

	exeinto "${MY_CGIBINDIR}"
	doexe bin/cgi/viewvc.cgi
	if use mysql; then
		doexe bin/cgi/query.cgi
	fi

	exeinto "${MY_CGIBINDIR}"
	if use mod_wsgi; then
		doexe bin/wsgi/viewvc.wsgi
		if use mysql; then
			doexe bin/wsgi/query.wsgi
		fi
	else
		doexe bin/wsgi/viewvc.fcgi
		if use mysql; then
			doexe bin/wsgi/query.fcgi
		fi
	fi

	webapp_configfile "${MY_HOSTROOTDIR}/conf/"{viewvc,cvsgraph}.conf

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst
	elog "Now read INSTALL in /usr/share/doc/${PF} to configure ${PN}"
}
