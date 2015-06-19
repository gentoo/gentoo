# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/zinnia/zinnia-0.06-r3.ebuild,v 1.4 2014/03/03 23:34:21 pacho Exp $

EAPI=5
PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils flag-o-matic toolchain-funcs autotools-utils

DESCRIPTION="Online hand recognition system with machine learning"
HOMEPAGE="http://zinnia.sourceforge.net/"
SRC_URI="mirror://sourceforge/zinnia/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
# Package warrants IUSE doc
IUSE="perl static-libs"
DOCS=( AUTHORS ChangeLog NEWS README )
PATCHES=(
	"${FILESDIR}/${P}-ricedown.patch"
	"${FILESDIR}/${P}-perl.patch"
)
AUTOTOOLS_AUTORECONF=yes

src_prepare() {
	autotools-utils_src_prepare
	if use perl ; then
			pushd "${S}/perl" >/dev/null
			PATCHES=()
			perl-module_src_prepare
			popd >/dev/null
	fi
}

src_compile() {
	autotools-utils_src_compile
	if use perl ; then
			pushd "${S}"/perl >/dev/null

			# We need to run this here as otherwise it won't pick up the
			# just-built -lzinnia and cause the extension to have
			# undefined symbols.
			perl-module_src_configure

			append-cppflags "-I${S}"
			append-ldflags "-L${S}/.libs"

			emake \
				LDDLFLAGS="-shared" \
				OTHERLDFLAGS="${LDFLAGS}" \
				CC="$(tc-getCXX)" LD="$(tc-getCXX)" \
				OPTIMIZE="${CPPFLAGS} ${CXXFLAGS}"
			popd >/dev/null
	fi
}

src_install() {
	autotools-utils_src_install

	if use perl ; then
			pushd "${S}/perl" >/dev/null
			perl-module_src_install
			popd >/dev/null
	fi

	# Curiously ChangeLog & NEWS are left uncompressed
	dohtml doc/*.html doc/*.css
}
