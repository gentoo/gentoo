# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="C library for executing name service queries asynchronously"
HOMEPAGE="http://0pointer.de/lennart/projects/libasyncns/"
SRC_URI="http://0pointer.de/lennart/projects/libasyncns/${P}.tar.gz"

SLOT="0"

LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux"

IUSE="doc debug"

BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default
	# fix libdir in pkgconfig file
	eapply "${FILESDIR}/${P}-libdir.patch"
	# fix configure check for res_query
	eapply "${FILESDIR}/${P}-configure-res_query.patch"
	eautoreconf
}

multilib_src_configure() {
	# libasyncns uses assert()
	use debug || append-cppflags -DNDEBUG

	ECONF_SOURCE=${S} \
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--disable-lynx \
		--disable-static
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi && use doc; then
		doxygen doxygen/doxygen.conf || die "doxygen failed"
	fi
}

multilib_src_install() {
	default

	if multilib_is_native_abi && use doc; then
		docinto apidocs
		dodoc -r html
	fi
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete
}
