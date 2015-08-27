# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools multilib toolchain-funcs

DESCRIPTION="Erasure Code API library written in C with pluggable Erasure Code backends."
HOMEPAGE="https://bitbucket.org/tsg-/liberasurecode/overview"
SRC_URI="https://bitbucket.org/tsg-/${PN}/get/v${PV}.tar.gz -> ${P}.tar.gz"
CUSTOM_VERSION="f61e907d2bbc"
S="${WORKDIR}/tsg--${PN}-${CUSTOM_VERSION}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND="sys-devel/autoconf
	doc? ( app-doc/doxygen )"

src_prepare() {
	sed -i -e 's/-O2\ //g' \
		-e 's/mmx\ /mmx2\ /g' \
		-e 's/cat\ g/#cat\ g/g' configure.ac || die
	sed -i -e "s/^TARGET_DIR.*$/TARGET_DIR=\/usr\/share\/doc\/${PF}\/html/g" doc/Makefile.am || die
	eautoreconf -i -v || die "autoconf failed"
}

src_configure() {
		econf --htmldir /usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install
	rm "${D}"/usr/$(get_libdir)/*.la || die
}
