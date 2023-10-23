# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/jvoisin/fortify-headers"
inherit git-r3

DESCRIPTION="A standalone implementation of fortify source"
HOMEPAGE="https://github.com/jvoisin/fortify-headers"

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

src_install() {
	export DESTDIR="${ED}"
	default
}
