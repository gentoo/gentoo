# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib

DESCRIPTION="Lisp-flavoured Erlang"
HOMEPAGE="http://lfe.github.io/"
SRC_URI="https://github.com/rvirding/lfe/archive/v0.7a.zip -> ${P}a.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/erlang"
DEPEND="${RDEPEND}"

#eh?
S=${WORKDIR}/${P}a

src_prepare() {
	sed -i -e 's/cp -pPR $(INCDIR) $(INSTALLDIR); \\/echo " "; \\/' Makefile || die
}

src_install() {
	ERL_LIBS="${D}/usr/$(get_libdir)/erlang/lib/" make install DESTDIR="${D}"
	mkdir -p "${D}"/usr/bin
	cp lfe "${D}"/usr/bin
}
