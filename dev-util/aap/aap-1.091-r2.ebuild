# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Bram Moolenaar's super-make program"
HOMEPAGE="http://www.a-a-p.org/"
SRC_URI="mirror://sourceforge/a-a-p/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND="${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
S=${WORKDIR}

src_install() {
	rm doc/*.sgml doc/*.pdf COPYING || die
	use doc && dohtml -r doc/*.html doc/images
	rm -r doc/*.html doc/images || die

	dodoc doc/*
	doman aap.1
	rm -r doc aap.1 || die

	# Move the remainder directly into the dest tree
	python_moduleinto /usr/share/aap
	python_domodule .

	# Create a symbolic link for the executable
	dosym ../share/aap/aap /usr/bin/aap
	python_fix_shebang "${ED}"/usr/share/aap/aap
}
