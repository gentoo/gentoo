# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo flag-o-matic toolchain-funcs

# no release/tag
QUICKJS_HASH=1fdc768fdc8571300755cdd3e4654ce99c0255ce

DESCRIPTION="Combination editor, browser, and mail client that is 100% text based"
HOMEPAGE="https://edbrowse.org"
SRC_URI="https://github.com/edbrowse/edbrowse/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bellard/quickjs/archive/${QUICKJS_HASH}.tar.gz -> quickjs-${QUICKJS_HASH}.tar.gz"

LICENSE="GPL-2+ curl MIT CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-db/unixODBC
	dev-libs/libpcre2:=
	dev-libs/openssl:=
	net-misc/curl
	sys-libs/readline:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
"

src_prepare() {
	default
	mv "${WORKDIR}"/quickjs-${QUICKJS_HASH} "${WORKDIR}"/quickjs || die
	pushd "${WORKDIR}" || die
	eapply "${FILESDIR}"/${PN}-3.8.12-userflags_quickjs.patch
	popd || die
}

src_compile() {
	tc-export CC AR PKG_CONFIG

	# First build quickjs so we can link to its static library.
	# Also, quickjs doesn't appear to tag releases.
	emake -C "${WORKDIR}"/quickjs libquickjs.a

	# set QUICKJS_LDFLAGS as upstream does except -ldl and -latomic (added only if available).
	append-atomic-flags
	emake -C src STRIP= QUICKJS_LDFLAGS="-L../../quickjs -lquickjs"
}

src_test() {
	# create an empty config file
	touch "${HOME}"/.ebrc || die
	# basic test
	echo -e "b ${S}/doc/usersguide.html\n1,3p\nqt" | edo ./src/edbrowse -d3 -e
}

src_install() {
	dobin src/edbrowse
	newman doc/man-edbrowse-debian.1 edbrowse.1
	local DOCS=( README doc/sample* )
	local HTML_DOCS=( doc/*.html )
	einstalldocs
}
