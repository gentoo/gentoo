# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/lxr/lxr-0.9.8-r1.ebuild,v 1.4 2014/11/09 22:09:37 dilfridge Exp $

EAPI=5

inherit perl-module webapp multilib eutils depend.apache

DESCRIPTION="general purpose source code indexer and cross-referener with a web-based frontend"
HOMEPAGE="http://sourceforge.net/projects/lxr"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ppc ~x86"
IUSE="cvs mysql postgres"
WEBAPP_MANUAL_SLOT="yes"
SLOT="0"

RDEPEND="dev-util/ctags
	dev-lang/perl
	dev-perl/DBI
	dev-perl/File-MMagic
	cvs? ( dev-vcs/rcs )
	postgres? ( dev-perl/DBD-Pg )
	mysql? ( dev-perl/DBD-mysql )"

need_apache2

pkg_setup() {
	webapp_pkg_setup
}

src_prepare() {

	epatch "${FILESDIR}/${PN}-0.9.8-initdb-mysql.patch"

	sed -i \
		-e 's|/usr/local/bin/swish-e|/usr/bin/swish-e|' \
		-e 's|/usr/bin/ctags|/usr/bin/exuberant-ctags|' \
		-e "s|'glimpse|#'glimpse|g" \
		-e "s:/path/to/lib:${VENDOR_LIB}:" \
		templates/lxr.conf || die "sed failed"
	sed -i \
		-e 's|Apache::Registry|ModPerl::PerlRun|' \
		.htaccess-apache1 || die "sed failed"
	sed -i \
		-e 's|require Local;|require LXR::Local;|' \
		-e 's|use Local;|use LXR::Local;|' \
		-e 's|package Local;|package LXR::Local;|' \
		Local.pm lib/LXR/Common.pm diff find ident search source || die "sed failed"
}

# prevent eclasses from overriding this
src_compile() { :; }

src_install() {
	perl_set_version
	webapp_src_preinst

	insinto "${VENDOR_LIB}"
	doins -r lib/LXR
	insinto "${VENDOR_LIB}"/LXR
	doins Local.pm

	dodoc BUGS CREDITS.txt ChangeLog HACKING INSTALL notes .htaccess* swish-e.conf

	exeinto "${MY_HTDOCSDIR}"
	doexe diff find genxref ident search source
	insinto "${MY_HTDOCSDIR}"
	doins .htaccess* templates/*

	webapp_configfile "${MY_HTDOCSDIR}"/lxr.conf "${MY_HTDOCSDIR}"/.htaccess-apache1
	webapp_sqlscript mysql initdb-mysql
	webapp_sqlscript postgresql initdb-postgres
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_hook_script "${FILESDIR}"/reconfig
	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst
}

pkg_prerm() {
	webapp_pkg_prerm
}
