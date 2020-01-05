# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_6} )
GENTOO_DEPEND_ON_PERL=no
inherit eutils multilib perl-module python-r1 toolchain-funcs

DESCRIPTION="A library which implements a curses-based widget set for text terminals"
HOMEPAGE="http://www.clifford.at/stfl/"
SRC_URI="http://www.clifford.at/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="examples perl python ruby static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	sys-libs/ncurses:0=[unicode]
	perl? ( dev-lang/perl:= )
	ruby? ( dev-lang/ruby:* )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	perl? ( dev-lang/swig )
	python? ( >=dev-lang/swig-1.3.40 )
	ruby? ( dev-lang/swig )
"

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
	epatch "${FILESDIR}"/${PN}-0.22-soname-symlink.patch
	epatch "${FILESDIR}"/${PN}-0.22-ruby-sharedlib.patch

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
		local BUILD_DIR="${S}/python"
		python_copy_sources

		# Based on code from python/Makefile.snippet.
		building() {
			pushd "${BUILD_DIR}" &>/dev/null || die
			echo swig -python -threads stfl.i
			swig -python -threads stfl.i || die
			echo "$(tc-getCC)" ${CFLAGS} ${LDFLAGS} -shared -pthread -fPIC stfl_wrap.c -I$(python_get_includedir) -I.. ../libstfl.so.${PV} -lncursesw -o _stfl.so
			"$(tc-getCC)" ${CFLAGS} ${LDFLAGS} -shared -pthread -fPIC stfl_wrap.c -I$(python_get_includedir) -I.. ../libstfl.so.${PV} -lncursesw -o _stfl.so || die
			popd &>/dev/null || die
		}
		python_foreach_impl building
	fi
}

src_install() {
	emake prefix="/usr" DESTDIR="${D}" libdir="$(get_libdir)" install

	if use python ; then
		local BUILD_DIR="${S}/python"

		installation() {
			pushd "${BUILD_DIR}" &>/dev/null || die
			python_domodule stfl.py _stfl.so
			popd &>/dev/null || die
		}
		python_foreach_impl installation
	fi

	dodoc README

	local exdir="/usr/share/doc/${PF}/examples"
	if use examples ; then
		insinto ${exdir}
		doins example.{c,stfl}
		insinto ${exdir}/python
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
