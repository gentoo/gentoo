# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="A highly efficient backup system based on the git packfile format"
HOMEPAGE="https://bup.github.io/ https://github.com/bup/bup"
SRC_URI="https://github.com/bup/bup/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test web"

RDEPEND="${PYTHON_DEPS}
	app-arch/par2cmdline
	dev-python/fuse-python[${PYTHON_USEDEP}]
	dev-python/pylibacl[${PYTHON_USEDEP}]
	dev-python/pyxattr[${PYTHON_USEDEP}]
	web? ( www-servers/tornado[${PYTHON_USEDEP}] )
	sys-libs/readline:0
	dev-vcs/git"
DEPEND="${RDEPEND}
	test? (
		dev-lang/perl
		net-misc/rsync
	)
	app-text/pandoc
"

# unresolved sandbox issues
RESTRICT="test"

src_prepare() {
	default

	sed -e "/^CFLAGS :=/s/-O2 -Werror//" \
		-i Makefile || die
}

src_configure() {
	./configure || die
}

src_test() {
	emake test
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr LIBDIR="/usr/$(get_libdir)/bup" DOCDIR="/usr/share/${PF}" install
	python_fix_shebang "${ED}"
	python_optimize "${ED}"
}
