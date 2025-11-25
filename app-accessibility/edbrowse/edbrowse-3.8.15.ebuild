# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Combination editor, browser, and mail client that is 100% text based"
HOMEPAGE="https://edbrowse.org"
SRC_URI="https://github.com/edbrowse/edbrowse/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ curl MIT CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-db/unixODBC
	dev-libs/libpcre2:=
	dev-libs/openssl:=
	dev-libs/quickjs-ng
	net-misc/curl
	sys-libs/readline:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
"

PATCHES=(
	# adapt makefile for shared quickjs-ng
	"${FILESDIR}"/${PN}-3.8.15-quickjs-ng.patch
)

src_compile() {
	tc-export CC PKG_CONFIG
	emake STRIP=
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
