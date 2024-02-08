# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="RFC3261 compliant SIP User-Agent library"
HOMEPAGE="https://github.com/freeswitch/sofia-sip"
SRC_URI="https://github.com/freeswitch/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+ BSD public-domain" # See COPYRIGHT
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-linux"
IUSE="debug doc glib test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl:=
	sys-libs/zlib:=
	glib? ( dev-libs/glib:2 )
"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
"

DOCS=(
	AUTHORS
	ChangeLog{,.ext-trees}
	README{,.developers}
	RELEASE
	SECURITY.md
	TODO
	docs/.
)

src_prepare() {
	local -a TESTS_DESELECT=(
		# Avoid tests that make too many assumptions about the
		# networking environment, bug 915904
		libsofia-sip-ua/sresolv:run_test_sresolv
		libsofia-sip-ua/nta:run_test_nta
		libsofia-sip-ua/nta:run_check_nta
		libsofia-sip-ua/nua:check_nua
		libsofia-sip-ua-glib/su-glib:torture_su_glib_timer
		libsofia-sip-ua-glib/su-glib:su_source_test
		tests:check_sofia
		tests:test_nua
	)

	local testname filename
	for deselect in "${TESTS_DESELECT[@]}"; do
		filename="${deselect%%:*}/Makefile.am"
		testname=${deselect#*:}
		sed -i -e "/TESTS/,$ s/\<${testname:?}\>//" "${filename:?}" || die
	done

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		# Makes otherwise working tests fail.
		ac_cv_tagstack=no

		# 'nth' depends on openssl (bug 851546, 880451) and can't be flipped off
		# without breaking API and ABI, so it should always be enabled.
		--enable-nth
		--with-openssl

		# ABI-breaking, cannot be controlled via USE-flags
		--disable-experimental
		--disable-sctp

		$(use_enable !debug ndebug)
		$(use_with doc doxygen)
		$(use_with glib)
	)
	econf "${myeconfargs[@]}"

	SOFIA_MAKEARGS=(
		# Make build logs verbose
		SOFIA_SILENT=
		VERBOSE=1
		# Prevent "/bin/sh /bin/sh" (bug 920903)
		TESTS_ENVIRONMENT=
	)
}

src_compile() {
	emake "${SOFIA_MAKEARGS[@]}"

	if use doc; then
		emake -C libsofia-sip-ua "${SOFIA_MAKEARGS[@]}" doxygen
		HTML_DOCS=( libsofia-sip-ua/docs/html/. )
	fi
}

src_test() {
	local -x SOFIA_DEBUG=9
	emake "${SOFIA_MAKEARGS[@]}" check
}

src_install() {
	emake DESTDIR="${D}" "${SOFIA_MAKEARGS[@]}" install
	einstalldocs

	find "${ED}" -name '*.la' -delete || die
}
