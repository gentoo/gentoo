# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Standalone implementation of fortify source"
HOMEPAGE="https://github.com/jvoisin/fortify-headers"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/jvoisin/fortify-headers"
	inherit git-r3
else
	FORTIFY_COMMIT=""
	SRC_URI="https://github.com/jvoisin/fortify-headers/archive/${FORTIFY_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86"
fi

LICENSE="ISC"
SLOT="0"

src_prepare() {
	sed -i -e 's|^PREFIX = /usr/local|PREFIX = /usr|g' Makefile || die
	default
}

src_compile() {
	# Nothing to do here but defining a dummy phase allows us to not trigger
	# the catch-all rule and try to install here where we don't have access
	# to ${ED}
	:;
}

src_test() {
	emake -C tests CC="$(tc-getCC)"
}

src_install() {
	export DESTDIR="${ED}"
	default
}
