# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit depend.apache

DESCRIPTION="A web based control pannel to manage Virtual Qmail Domains. Works with qmailadmin"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.inter7.com/${PN}"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
DEPEND=">=net-mail/vpopmail-5.3
		virtual/qmail"
RDEPEND="${DEPEND}
	net-mail/qmailadmin"

need_apache

src_compile() {
	local dir_vhost="/var/www/localhost/"
	local dir_vpopmail="/var/vpopmail"
	local dir_htdocs="${dir_vhost}/htdocs/${PN}"
	local dir_htdocs_images="${dir_htdocs}/images"
	local url_htdocs_images="/${PN}/images"
	local dir_cgibin="${dir_vhost}/cgi-bin"
	local url_cgibin="/cgi-bin/${PN}"
	local dir_htdocs_htmlib="/usr/share/${PN}/htmllib"
	local dir_qmail="/var/qmail"
	local bin_true="/bin/true"
	local dir_ezmlm="/usr/bin"
	local dir_autorespond="/var/qmail/bin"
	sed -e "3356iwwwroot='${dir_htdocs}'" -e '3356,3369d' -i configure || die "failed to fix configure"

	find . -name 'Makefile*' -o -name '*.c' -o -name '*.html' | xargs -n1 -t sed 's|images/vqadmin|vqadmin/images|g' -i

	econf ${myopts} \
	--enable-vpopmaildir=${dir_vpopmail} \
	--enable-htmldir=${dir_htdocs} \
	--enable-imageurl=${url_htdocs_images} \
	--enable-imagedir=${dir_htdocs_images} \
	--enable-htmllibdir=${dir_htdocs_htmlib} \
	--enable-qmaildir=${dir_qmail} \
	--enable-true-path=${bin_true} \
	--enable-ezmlmdir=${dir_ezmlm} \
	--enable-cgibindir=${dir_cgibin} \
	--enable-cgipath=${url_cgibin} \
	--enable-vpopuser=vpopmail \
	--enable-vpopgroup=vpopmail \
	|| die "econf failed"

	sed 's|/vqadmin/vqadmin/|/vqadmin/|g' -i Makefile

	emake || die
	sed -e "/install-exec-local:/,/chmod go+r/s|${dir_vhost}|\$(DESTDIR)${dir_vhost}|" -i Makefile
}

src_install () {
	make DESTDIR=${D} install || die

	# Install documentation.
	dodoc ACL AUTHORS BUGS ChangeLog FAQ INSTALL NEWS TODO README
}

#pkg_config() {
#
#	einfo "Performing post-installation routines for ${P}."
#
#	cat > ${REAL_CGIBINDIR}/vqadmin/vqadmin.conf <<EOF
#<Directory "${REAL_CGIBINDIR}/vqadmin">
#	deny from all
#	Options ExecCGI
#	AllowOverride AuthConfig
#	Order deny,allow
#</Directory>
#EOF
#
#	# Including configuration to the apache config file
#	echo "Include ${REAL_CGIBINDIR}/vqadmin/vqadmin.conf" >> /etc/apache/conf/apache.conf
#
#	# Creating .htaccess
#	einfo ""
#	einfo "We need to create an htaccess for the directory so Apache knows"
#	einfo "how to authenticate users trying to access the directory."
#	cat > ${REAL_CGIBINDIR}/vqadmin/.htaccess <<EOF
#AuthType Basic
#AuthUserFile /etc/apache/conf/vqadmin.passwd
#AuthName vqadmin
#require valid-user
#satisfy any
#EOF
#	# Tightening Permissions
#	chown apache.apache ${REAL_CGIBINDIR}/vqadmin/.htaccess
#	chmod 600 ${REAL_CGIBINDIR}/vqadmin/.htaccess
#
#	# How set up users ?
#	einfo "Now, You can create a user. Example: "
#	einfo "	  htpasswd -c /etc/apache/conf/vqadmin.passwd username"
#	einfo "then: "
#	einfo "	  cd /etc/apache/conf/ && chown root.apache vqadmin.passwd"
#	einfo "	  chmod 640 vqadmin.passwd"
#	einfo ""
#	einfo "IMPORTANT ! Use the -c (-create) switch ONLY the first time"
#	einfo "IMPORTANT ! You will have to restart apache to get vqadmin working"
#}

#pkg_postrm() {
#	rm -rf ${REAL_CGIBINDIR}/vqadmin/vqadmin.conf
#	rm -rf ${REAL_CGIBINDIR}/vqadmin/.htaccess
#	rmdir ${REAL_CGIBINDIR}/vqadmin
#	sed "/^Include.*vqadmin.conf$/d" /etc/apache/conf/apache.conf > /etc/apache/conf/apache.conf.new
#	mv --force /etc/apache/conf/apache.conf.new /etc/apache/conf/apache.conf
#}
