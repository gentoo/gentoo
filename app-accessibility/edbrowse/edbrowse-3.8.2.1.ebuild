# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
QUICKJS_HASH=2788d71e823b522b178db3b3660ce93689534e6d
QUICKJS_SHORT=2788d71
QUICKJS_S="${WORKDIR}/quickjs-${QUICKJS_HASH}"
QUICKJS_P="quickjs-${QUICKJS_SHORT}"

DESCRIPTION="Combination editor, browser, and mail client that is 100% text based"
HOMEPAGE="https://edbrowse.org"
SRC_URI="https://github.com/CMB/edbrowse/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bellard/quickjs/archive/${QUICKJS_HASH}.tar.gz -> ${QUICKJS_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="odbc"

RDEPEND="
	>=app-text/htmltidy-5.0.0:=
	dev-libs/libpcre2:=
	net-misc/curl
	sys-libs/readline:=
	odbc? ( dev-db/unixODBC )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	sys-apps/ed
	virtual/pkgconfig"

	PATCHES=(
		"${FILESDIR}/${P}"-respect-ldflags.patch
	)

src_compile() {
	# First build quickjs so we can link to its static library.
	# Also, quickjs doesn't appear to tag releases.
	tools/quickjobfixup "${QUICKJS_S}" || die
	emake -C "${QUICKJS_S}"
	emake -C src QUICKJS_DIR="${QUICKJS_S}" STRIP=
}

src_install() {
	dobin src/edbrowse
	newman doc/man-edbrowse-debian.1 edbrowse.1
	DOCS="doc/sample*"
	HTML_DOCS="doc/*.html"
	einstalldocs
}
