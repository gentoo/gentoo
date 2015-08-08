# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Please note: apache, java, mono and ruby support disabled for now.
# Fill a bug if you need it.
#
# dju@gentoo.org, 4th July 2005

EAPI=5
GENTOO_DEPEND_ON_PERL="no"
PYTHON_DEPEND="python? 2"

inherit autotools eutils multilib perl-app python

DESCRIPTION="Clearsilver is a fast, powerful, and language-neutral HTML template system"
HOMEPAGE="http://www.clearsilver.net/"
SRC_URI="http://www.clearsilver.net/downloads/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="perl python zlib"

DEPEND="perl? ( dev-lang/perl:= )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

DOCS=(README INSTALL)

pkg_setup() {
	if use python; then
		DOCS+=(README.python)

		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-perl_installdir.patch

	use zlib && epatch "${FILESDIR}"/${P}-libz.patch

	epatch "${FILESDIR}"/${P}-libdir.patch
	sed -i -e "s:GENTOO_LIBDIR:$(get_libdir):" configure.in
	eautoreconf

	# Fix for Gentoo/Freebsd
	[[ "${ARCH}" == FreeBSD ]] && touch ${S}/features.h ${S}/cgi/features.h
}

src_configure() {
	econf \
		$(use_enable perl) \
		$(use_with perl perl /usr/bin/perl) \
		$(use_enable python) \
		$(use_with python python /usr/bin/python) \
		$(use_enable zlib compression) \
		"--disable-apache" \
		"--disable-ruby" \
		"--disable-java" \
		"--disable-csharp"
}

src_compile() {
	default
}

src_install () {
	default

	if use perl ; then
		perl_delete_localpod || die "perl_delete_localpod failed"
	fi
}
