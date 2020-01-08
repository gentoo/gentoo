# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.5
inherit flag-o-matic netsurf

DESCRIPTION="library for building efficient parsers, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libparserutils/"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~ppc x86 ~m68k-mint"
IUSE="iconv test"
RESTRICT="!test? ( test )"

DEPEND="test? (	dev-lang/perl )"

DOCS=( README docs/Todo )

src_configure() {
	netsurf_src_configure

	append-cflags "-D$(usex iconv WITH WITHOUT)_ICONV_FILTER"
}
