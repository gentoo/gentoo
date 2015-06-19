# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/stfl/stfl-0.22-r2.ebuild,v 1.2 2014/11/17 23:25:14 dilfridge Exp $

EAPI="5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython"

inherit eutils multilib perl-module python toolchain-funcs

DESCRIPTION="A library which implements a curses-based widget set for text terminals"
HOMEPAGE="http://www.clifford.at/stfl/"
SRC_URI="http://www.clifford.at/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

IUSE="examples perl python ruby static-libs"

COMMON_DEPEND="sys-libs/ncurses[unicode]
	perl? ( dev-lang/perl )
	ruby? ( dev-lang/ruby )
	python? ( dev-lang/python )"

DEPEND="${COMMON_DEPEND}
	perl? ( dev-lang/swig )
	python? ( >=dev-lang/swig-1.3.40 )
	ruby? ( dev-lang/swig )"

RDEPEND="${COMMON_DEPEND}"

pkg_setup() {
	use python && python_pkg_setup
}

src_prepare() {
	sed -i \
		-e 's/-Os -ggdb//' \
		-e 's/^\(all:.*\) example/\1/' \
		-e 's/$(CC) -shared/$(CC) $(LDFLAGS) -shared/' \
		-e 's/ -o $@ $(LDLIBS) $^/ $^ $(LDLIBS) -o $@/' \
		-e 's/-lncursesw/-lncursesw -pthread/' \
		Makefile || die "sed failed"

	if ! use static-libs ; then
		sed -i -e "/install .* libstfl.a/d" Makefile || die
	fi

	epatch "${FILESDIR}"/${PN}-0.21-python.patch
	epatch "${FILESDIR}"/${P}-soname-symlink.patch
	epatch "${FILESDIR}"/${P}-ruby-sharedlib.patch

	if use perl ; then
		echo "FOUND_PERL5=1" >> Makefile.cfg
	else
		echo "FOUND_PERL5=0" >> Makefile.cfg
	fi

	if use ruby ; then
		echo "FOUND_RUBY=1" >> Makefile.cfg
	else
		echo "FOUND_RUBY=0" >> Makefile.cfg
	fi

	echo "FOUND_PYTHON=0" >> Makefile.cfg
}

src_configure() { :; }

src_compile() {
	emake CC="$(tc-getCC)"

	if use python ; then
		python_copy_sources python

		# Based on code from python/Makefile.snippet.
		building() {
			echo swig -python -threads stfl.i
			swig -python -threads stfl.i
			echo "$(tc-getCC)" ${CFLAGS} ${LDFLAGS} -shared -pthread -fPIC stfl_wrap.c -I$(python_get_includedir) -I.. ../libstfl.so.${PV} -lncursesw -o _stfl.so
			"$(tc-getCC)" ${CFLAGS} ${LDFLAGS} -shared -pthread -fPIC stfl_wrap.c -I$(python_get_includedir) -I.. ../libstfl.so.${PV} -lncursesw -o _stfl.so
		}
		python_execute_function -s --source-dir python building
	fi
}

src_install() {
	emake prefix="/usr" DESTDIR="${D}" libdir="$(get_libdir)" install

	if use python ; then
		installation() {
			insinto $(python_get_sitedir)
			doins stfl.py _stfl.so
		}
		python_execute_function -s --source-dir python installation
	fi

	dodoc README

	local exdir="/usr/share/doc/${PF}/examples"
	if use examples ; then
		insinto ${exdir}
		doins example.{c,stfl}
		insinto  ${exdir}/python
		doins python/example.py
		if use perl ; then
			insinto ${exdir}/perl
			doins perl5/example.pl
		fi
		if use ruby ; then
			insinto ${exdir}/ruby
			doins ruby/example.rb
		fi
	fi

	perl_delete_localpod
}

pkg_postinst() {
	use python && python_mod_optimize stfl.py
}

pkg_postrm() {
	use python && python_mod_cleanup stfl.py
}
