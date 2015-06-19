# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Mason/HTML-Mason-1.540.0.ebuild,v 1.5 2015/06/13 22:50:35 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JSWARTZ
MODULE_VERSION=1.54
inherit depend.apache perl-module

DESCRIPTION="A HTML development and delivery Perl Module"
HOMEPAGE="http://www.masonhq.com/ ${HOMEPAGE}"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="modperl test"

RDEPEND="!modperl? ( dev-perl/CGI )
	modperl? (
		www-apache/libapreq2
		>=www-apache/mod_perl-2
	)
	>=dev-perl/Params-Validate-0.7
	>=dev-perl/Class-Container-0.08
	>=dev-perl/Exception-Class-1.15
	dev-perl/HTML-Parser
	virtual/perl-Scalar-List-Utils
	virtual/perl-File-Spec
	>=dev-perl/Cache-Cache-1.01
	dev-perl/Log-Any"

DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( dev-perl/Test-Deep )"

want_apache2 modperl

SRC_TEST="do"
mydoc="CREDITS UPGRADE"
myconf="--noprompts"

pkg_setup() {
	depend.apache_pkg_setup modperl
	perl_set_version
}

src_prepare() {
	# Note about new modperl use flag
	if use !modperl ; then
		ewarn "HTML-Mason will only install with modperl support"
		ewarn "if the use flag modperl is enabled."
	fi
	# rendhalver - needed to set an env var for the build script so it finds our apache.
	export APACHE="${APACHE_BIN}"
	perl-module_src_prepare
}

src_install () {
	perl-module_src_install
	mv "${ED}"/usr/bin/convert* "${ED}"/usr/share/doc/${PF} || die
}
