# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

DESCRIPTION="Lisp-flavoured Erlang"
HOMEPAGE="http://lfe.github.io/"
SRC_URI="https://github.com/rvirding/lfe/archive/v${PV}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/erlang"
DEPEND="${RDEPEND}"

src_prepare() {
	export PATH="${S}/bin:$PATH"
}

src_compile() {
	emake compile -j1
}

src_install() {
	dobin bin/lfe
	dobin bin/lfec
	dobin bin/lfescript
	dodir /usr/$(get_libdir)/erlang/lib/lfe/ebin/
	dodir /usr/$(get_libdir)/erlang/lib/lfe/emacs/
	cp -R "${S}/ebin" "${D}/usr/$(get_libdir)/erlang/lib/lfe/"
	cp -R "${S}/emacs" "${D}/usr/$(get_libdir)/erlang/lib/lfe/"
}
