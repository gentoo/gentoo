# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

DESCRIPTION="Lisp-flavoured Erlang"
HOMEPAGE="http://lfe.github.io/"
SRC_URI="https://github.com/rvirding/lfe/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/erlang"
DEPEND="${RDEPEND}"

src_prepare() {
	export PATH="${S}/bin:$PATH"
	eapply_user
}

src_compile() {
	emake compile -j1
}

src_install() {
	dobin bin/lfe
	dobin bin/lfec
	dobin bin/lfescript
	insinto /usr/$(get_libdir)/erlang/lib/lfe
	doins -r ebin || die
	doins -r emacs || die
}
