# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xerces-c/xerces-c-3.1.1-r1.ebuild,v 1.11 2015/01/28 19:42:36 mgorny Exp $

EAPI="2"

inherit eutils

DESCRIPTION="A validating XML parser written in a portable subset of C++"
HOMEPAGE="http://xerces.apache.org/xerces-c/"
SRC_URI="mirror://apache/xerces/c/3/sources/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-fbsd ~x86-linux"
IUSE="curl doc iconv icu cpu_flags_x86_sse2 static-libs threads elibc_Darwin elibc_FreeBSD"

RDEPEND="icu? ( >=dev-libs/icu-4.2 )
	curl? ( net-misc/curl )
	virtual/libiconv"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

pkg_setup() {
	export ICUROOT="/usr"

	if use iconv && use icu ; then
		ewarn "This package can use iconv or icu for loading messages"
		ewarn "and transcoding, but not both. ICU will precede."
	fi
}

src_prepare() {
	use threads || epatch "${FILESDIR}/${PV}-disable-thread-tests.patch"

	sed -i \
		-e 's|$(prefix)/msg|$(DESTDIR)/$(prefix)/share/xerces-c/msg|' \
		src/xercesc/util/MsgLoaders/MsgCatalog/Makefile.in || die "sed failed"
}

src_configure() {
	local mloader="inmemory"
	use iconv && mloader="iconv"
	use icu && mloader="icu"

	local transcoder="gnuiconv"
	use elibc_FreeBSD && transcoder="iconv"
	use elibc_Darwin && transcoder="macosunicodeconverter"
	use icu && transcoder="icu"
	# for interix maybe: transcoder="windows"

	# 'cfurl' is only available on OSX and 'socket' isn't supposed to work.
	# But the docs aren't clear about it, so we would need some testing...
	local netaccessor="socket"
	use elibc_Darwin && netaccessor="cfurl"
	use curl && netaccessor="curl"

	econf \
		--disable-pretty-make \
		$(use_enable static-libs static) \
		$(use_enable threads) \
		--enable-msgloader-${mloader} \
		--enable-netaccessor-${netaccessor} \
		--enable-transcoder-${transcoder} \
		$(use_enable cpu_flags_x86_sse2 sse2)
}

src_compile() {
	default

	if use doc ; then
		cd "${S}/doc"
		doxygen || die "making docs failed"
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die "emake failed"

	use static-libs || rm "${D}"/lib*/*.la

	# To make sure an appropriate NLS msg file is around when using the iconv msgloader
	# ICU has the messages compiled in.
	if use iconv && ! use icu ; then
		doenvd "${FILESDIR}/50xerces-c"
	fi

	if use doc; then
		insinto /usr/share/doc/${PF}
		rm -rf samples/Makefile* samples/runConfigure samples/src/*/Makefile* samples/.libs
		doins -r samples
		dohtml -r doc/html/*
	fi

	dodoc CREDITS KEYS NOTICE README version.incl
}
