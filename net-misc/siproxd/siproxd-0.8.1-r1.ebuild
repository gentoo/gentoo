# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/siproxd/siproxd-0.8.1-r1.ebuild,v 1.1 2014/03/03 13:47:10 polynomial-c Exp $

EAPI=5

inherit eutils autotools user

DESCRIPTION="A proxy/masquerading daemon for the SIP protocol"
HOMEPAGE="http://siproxd.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples doc static"
# TODO: debug can be used but dmalloc is breaking the build
# upstream has been contacted, see bug 2649238 in their bugtracker

RDEPEND=">=net-libs/libosip-3.0.0
	<net-libs/libosip-4.0.0"
#	debug? ( dev-libs/dmalloc[threads] )"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.4
	doc? ( app-text/docbook-sgml-utils
		app-text/docbook-sgml-dtd:4.2 )"
# docbook-sgml-utils is for building doc
# docbook-sgml-dtd is for the doc dtd even if docbook-sgml-utils depends on it

pkg_setup() {
	enewgroup siproxd
	enewuser siproxd -1 -1 /dev/null siproxd
}

src_prepare() {
	# make the daemon run as user 'siproxd' by default
	sed -i -e "s:nobody:siproxd:" doc/siproxd.conf.example \
		|| die "patching doc/siproxd.conf.example failed"
	# do not fail when building with external libltdl
	sed -i 's/libltdl //' Makefile.am || die "patching Makefile failed"
	epatch "${FILESDIR}/${PN}-libtool-2.4.patch"
	# do not crash when building with external libltdl, bug 308495
	sed -i 's|"../libltdl/ltdl.h"|<ltdl.h>|' src/plugins.h || die "patching plugins.h failed"

	epatch "${FILESDIR}/${PN}-0.8.1-amd64_static_build.patch" #380835

	eautoreconf
}

src_configure() {
	# static-libosip2 make it link statically against libosip2
	# static build static version of plugins, forced to true
	econf \
		$(use_enable doc) \
		$(use_enable static static-libosip2) \
		$(use_enable !static shared) \
		--enable-static
		#$(use debug && use_enable debug dmalloc) \

	# statically linked plugins to libosip2 causes a shared lib linking with
	# static lib (gcc seems not to like it : portable issue it says).
	# there was also DT_TEXREL issue and stripping of static plugins failed
	# so shared lib has to be used for plugins
	# upstream has been contacted, see bug 2649351 in their bugtracker
	if use static; then
		sed -i -r -e \
			"s:LIBS =(.*)( \/[^ ]*libosip[^ ]*\.a)( \/[^ ]*libosip[^ ]*\.a)(.*):LIBS_STATIC =\1\2\3\4\nLIBS = \1\4 -losip2 -losipparser2:" \
			src/Makefile || die "patching src/Makefile failed"
		sed -i -e \
			"s:\$(siproxd_LDADD) \$(LIBS):\$(siproxd_LDADD) \$(LIBS_STATIC):" \
			src/Makefile || die "patching src/Makefile failed"
	fi
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.rc8 ${PN}

	dodoc AUTHORS ChangeLog NEWS README RELNOTES TODO \
		doc/FAQ doc/FLI4L_HOWTO.txt doc/KNOWN_BUGS

	if use doc; then
		dodoc doc/RFC3261_compliance.txt
		# auto-generated doc is not auto-installed
		# upstream has been contacted, see bug 2649333 in their bugtracker
		dohtml -r doc/html/
		# pdf is not build all the time
		if has_version 'app-text/docbook-sgml-utils[jadetex]' ; then
			dodoc doc/pdf/*.pdf
		fi
	fi

	if use examples; then
		docinto examples
		dodoc doc/sample_*.txt
	fi

	# set up siproxd directories
	keepdir /var/lib/${PN}
	fowners siproxd:siproxd /var/lib/${PN}
}

pkg_postinst() {
	if use static; then
		elog "static USE flag does not build a _fully_ statically linked binary"
		elog "only libosip2 and libosipparser2 are statically linked"
		elog "In addition, plugins are dynamically linked with those libs"
	fi
}
