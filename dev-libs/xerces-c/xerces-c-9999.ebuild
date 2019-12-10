# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
: ${CMAKE_MAKEFILE_GENERATOR:=ninja}

inherit cmake-utils prefix

DESCRIPTION="A validating XML parser written in a portable subset of C++"
HOMEPAGE="https://xerces.apache.org/xerces-c/"

if [[ ${PV} == *9999 ]] ; then
	ESVN_REPO_URI="https://svn.apache.org/repos/asf/xerces/c/trunk"
	inherit subversion
else
	SRC_URI="mirror://apache/xerces/c/3/sources/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
fi

LICENSE="Apache-2.0"
SLOT="0"

IUSE="cpu_flags_x86_sse2 curl doc elibc_Darwin elibc_FreeBSD examples iconv icu static-libs test threads"
RESTRICT="!test? ( test )"

RDEPEND="icu? ( dev-libs/icu:0= )
	curl? ( net-misc/curl )
	virtual/libiconv"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-lang/perl )"

DOCS=( CREDITS KEYS NOTICE README )

pkg_setup() {
	export ICUROOT="${EPREFIX}/usr"

	if use iconv && use icu; then
		ewarn "This package can use iconv or icu for loading messages"
		ewarn "and transcoding, but not both. ICU takes precedence."
	fi
}

src_configure() {
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

	local mycmakeargs=(
		-Dnetwork-accessor="${netaccessor}"
		-Dmessage-loader="${msgloader}"
		-Dtranscoder="${transcoder}"
		-Dthreads:BOOL="$(usex threads)"
		-Dsse2:BOOL="$(usex cpu_flags_x86_sse2)"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use doc && cmake-utils_src_compile doc-style createapidocs doc-xml
}

src_install () {
	cmake-utils_src_install

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
		doenvd "$(prefixify_ro "${FILESDIR}/50xerces-c")"
	fi
}
