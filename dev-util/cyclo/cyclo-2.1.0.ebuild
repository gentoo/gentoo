# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Computes cyclomatic complexity metrics on C source code."
HOMEPAGE="https://github.com/sarnold/cyclo"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/cyclo.git"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
SLOT="0"
LICENSE="GPL-2"
IUSE="debug"

DEPEND="sys-devel/flex"

src_compile() {
	local my_opts
	my_opts="CC=$(tc-getCC) CXX=$(tc-getCXX)"

	if ! use debug ; then
		DBG="" emake ${my_opts} || die "make failed"
	else
		export STRIP_MASK="*/bin/*"
		if [ -n "${DEBUG}" ] ; then
			DBG="${DEBUG}" emake ${my_opts} \
				|| die "make debug failed"
		else
			emake ${my_opts} || die "make debug failed"
		fi
	fi
}

src_test() {
	make -f Makefile.test test
}

src_install() {
	emake PREFIX=/usr DESTDIR="${ED}" install
}
