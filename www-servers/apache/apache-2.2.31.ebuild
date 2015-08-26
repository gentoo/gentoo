# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# latest gentoo apache files
GENTOO_PATCHSTAMP="20140922"
GENTOO_DEVELOPER="polynomial-c"
GENTOO_PATCHNAME="gentoo-apache-2.2.29"

# IUSE/USE_EXPAND magic
IUSE_MPMS_FORK="itk peruser prefork"
IUSE_MPMS_THREAD="event worker"

IUSE_MODULES="actions alias asis auth_basic auth_digest authn_alias authn_anon
authn_dbd authn_dbm authn_default authn_file authz_dbm authz_default
authz_groupfile authz_host authz_owner authz_user autoindex cache cern_meta
charset_lite cgi cgid dav dav_fs dav_lock dbd deflate dir disk_cache dumpio
env expires ext_filter file_cache filter headers ident imagemap include info
log_config log_forensic logio mem_cache mime mime_magic negotiation proxy
proxy_ajp proxy_balancer proxy_connect proxy_ftp proxy_http proxy_scgi rewrite
reqtimeout setenvif speling status substitute unique_id userdir usertrack
version vhost_alias"
# The following are also in the source as of this version, but are not available
# for user selection:
# bucketeer case_filter case_filter_in echo http isapi optional_fn_export
# optional_fn_import optional_hook_export optional_hook_import

# inter-module dependencies
# TODO: this may still be incomplete
MODULE_DEPENDS="
	dav_fs:dav
	dav_lock:dav
	deflate:filter
	disk_cache:cache
	ext_filter:filter
	file_cache:cache
	log_forensic:log_config
	logio:log_config
	mem_cache:cache
	mime_magic:mime
	proxy_ajp:proxy
	proxy_balancer:proxy
	proxy_connect:proxy
	proxy_ftp:proxy
	proxy_http:proxy
	proxy_scgi:proxy
	substitute:filter
"

# module<->define mappings
MODULE_DEFINES="
	auth_digest:AUTH_DIGEST
	authnz_ldap:AUTHNZ_LDAP
	cache:CACHE
	dav:DAV
	dav_fs:DAV
	dav_lock:DAV
	disk_cache:CACHE
	file_cache:CACHE
	info:INFO
	ldap:LDAP
	mem_cache:CACHE
	proxy:PROXY
	proxy_ajp:PROXY
	proxy_balancer:PROXY
	proxy_connect:PROXY
	proxy_ftp:PROXY
	proxy_http:PROXY
	ssl:SSL
	status:STATUS
	suexec:SUEXEC
	userdir:USERDIR
"

# critical modules for the default config
MODULE_CRITICAL="
	authz_host
	dir
	mime
"

inherit apache-2 systemd toolchain-funcs

DESCRIPTION="The Apache Web Server"
HOMEPAGE="http://httpd.apache.org/"

# some helper scripts are Apache-1.1, thus both are here
LICENSE="Apache-2.0 Apache-1.1"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

src_configure() {
	# Brain dead check.
	tc-is-cross-compiler && export ap_cv_void_ptr_lt_long="no"

	apache-2_src_configure
}

src_install() {
	apache-2_src_install

	# install apxs in /usr/bin (bug #502384) and put a symlink into the
	# old location until all ebuilds and eclasses have been modified to
	# use the new location.
	local apxs_dir="/usr/bin"
	dodir ${apxs_dir}
	mv "${D}"/usr/sbin/apxs "${D}"${apxs_dir} || die
	ln -s ../bin/apxs "${D}"/usr/sbin/apxs || die

	systemd_newunit "${FILESDIR}/apache2.2.service" "apache2.service"
	systemd_dotmpfilesd "${FILESDIR}/apache.conf"
}
