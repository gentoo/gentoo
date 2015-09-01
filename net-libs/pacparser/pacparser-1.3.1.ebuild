# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit eutils python-r1 multilib

DESCRIPTION="Library to parse proxy auto-config files"
HOMEPAGE="https://github.com/pacparser/pacparser"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc python"

DEPEND="python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# spidermonkey-1.7.0 is bundled
# tested unbundling with spidermonkey-1.8* and 17
# failures : unbundling not worth

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	export NO_INTERNET=yes
}

src_compile() {
	emake -j1 -C src
	use python && python_foreach_impl emake -j1 -C src pymod
}

src_test() {
	emake -j1 -C src testpactester
	use python && emake -j1 -C src test-pymod
}

src_install() {
	emake DESTDIR="${ED}" LIB_PREFIX="${ED}/usr/$(get_libdir)" -C src install
	dodoc README
	use python && python_foreach_impl \
		emake DESTDIR="${D}" \
		LIB_PREFIX="${D}/usr/$(get_libdir)" -C src install-pymod
	use doc && emake DESTDIR="${ED}" \
		DOC_PREFIX="${ED}/usr/share/doc/${PF}" -C src install-docs
	# conflicts (bug #509168), and useless
	rm "${ED}"/usr/share/man/man3/deprecated.3 || die
}
