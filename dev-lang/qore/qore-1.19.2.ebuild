# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Qore, the embeddable multithreaded scripting language"
HOMEPAGE="http://qore.org/
	https://github.com/qorelanguage/qore/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/qorelanguage/${PN}.git"
else
	SRC_URI="https://github.com/qorelanguage/${PN}/archive/release-${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-release-${PV}"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-2+ LGPL-2.1+ MIT"
SLOT="0"
IUSE="debug"

RDEPEND="
	app-arch/bzip2:=
	dev-libs/libpcre:=
	dev-libs/mpfr:=
	dev-libs/openssl:=
	sys-libs/zlib:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# Needs "bison" and "flex" exactly.
	unset LEX
	unset YACC

	local -a myconf=(
		--disable-optimization
		--disable-profile
		--disable-static-bz2
		--disable-static-common
		--disable-static-openssl
		--disable-static-pcre
		--disable-static-zlib
		$(use_enable debug)
	)
	econf "${myconf[@]}"
}

src_test() {
	PATH="${S}:${PATH}" emake check
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete ||
		die "failed to remove libtool files without corresponding static libraries"
}
