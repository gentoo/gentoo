# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=1.56
inherit depend.apache perl-module

DESCRIPTION="A HTML development and delivery Perl Module"
HOMEPAGE="http://www.masonhq.com/ ${HOMEPAGE}"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="modperl test"

RDEPEND="
	!modperl? ( >=dev-perl/CGI-2.460.0 )
	modperl? (
		www-apache/libapreq2
		>=www-apache/mod_perl-2
	)
	>=dev-perl/Cache-Cache-1
	>=dev-perl/Class-Container-0.70.0
	>=dev-perl/Exception-Class-1.150.0
	virtual/perl-File-Spec
	dev-perl/HTML-Parser
	>=dev-perl/Log-Any-0.80.0
	>=dev-perl/Params-Validate-0.70.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Deep
	)
"
PATCHES=( "${FILESDIR}/${P}-no-dot-inc.patch" )

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
