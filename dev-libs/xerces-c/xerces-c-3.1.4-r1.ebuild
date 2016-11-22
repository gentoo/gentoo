# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="A validating XML parser written in a portable subset of C++"
HOMEPAGE="http://xerces.apache.org/xerces-c/"
SRC_URI="mirror://apache/xerces/c/3/sources/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ppc ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"

IUSE="cpu_flags_x86_sse2 curl doc elibc_Darwin elibc_FreeBSD examples iconv icu static-libs test threads"

RDEPEND="icu? ( dev-libs/icu:0= )
	curl? ( net-misc/curl )
	virtual/libiconv"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-lang/perl )"

DOCS=( CREDITS KEYS NOTICE README version.incl )
PATCHES=( "${FILESDIR}/${PN}-3.1.4-fix-build-system.patch" )

pkg_setup() {
	export ICUROOT="/usr"

	if use iconv && use icu; then
		ewarn "This package can use iconv or icu for loading messages"
		ewarn "and transcoding, but not both. ICU takes precedence."
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local msgloader
	if use icu; then
		msgloader="icu"
	elif use iconv; then
		msgloader="iconv"
	else
		msgloader="inmemory"
	fi

	local transcoder
	if use icu; then
		transcoder="icu"
	elif use elibc_Darwin; then
		transcoder="macosunicodeconverter"
	elif use elibc_FreeBSD; then
		transcoder="iconv"
	else
		transcoder="gnuiconv"
	fi
	# for interix maybe: transcoder="windows"

	# 'cfurl' is only available on OSX and 'socket' isn't supposed to work.
	# But the docs aren't clear about it, so we would need some testing...
	local netaccessor
	if use curl; then
		netaccessor="curl"
	elif use elibc_Darwin; then
		netaccessor="cfurl"
	else
		netaccessor="socket"
	fi

	econf \
		--disable-pretty-make \
		--enable-msgloader-${msgloader} \
		--enable-transcoder-${transcoder} \
		--enable-netaccessor-${netaccessor} \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable threads) \
		$(use_enable static-libs static)
}

src_compile() {
	default

	if use doc; then
		cd doc || die
		doxygen || die "making docs failed"
		HTML_DOCS=( doc/html/. )
	fi
}

src_install () {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die

	if use examples; then
		# clean out object files, executables, Makefiles
		# and the like before installing examples
		find samples/ \( -type f -executable -o -iname 'runConfigure' -o -iname '*.o' \
			-o -iname '.libs' -o -iname 'Makefile*' \) -exec rm -rf '{}' + || die
		docinto examples
		dodoc -r samples/.
		docompress -x /usr/share/doc/${PF}/examples
	fi

	# To make sure an appropriate NLS msg file is around when using
	# the iconv msgloader ICU has the messages compiled in.
	if use iconv && ! use icu; then
		doenvd "${FILESDIR}/50xerces-c"
	fi
}
