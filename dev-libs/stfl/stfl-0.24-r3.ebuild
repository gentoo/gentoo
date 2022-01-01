# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..8} )
GENTOO_DEPEND_ON_PERL=no
inherit eutils multilib perl-module python-r1 toolchain-funcs

DESCRIPTION="A library which implements a curses-based widget set for text terminals"
HOMEPAGE="http://www.clifford.at/stfl/"
SRC_URI="http://www.clifford.at/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 x86"
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
RESTRICT="test"  # Upstream does not provide tests #730112

PATCHES=(
	"${FILESDIR}/${PN}-0.21-python.patch"
	"${FILESDIR}/${PN}-0.22-soname-symlink.patch"
	"${FILESDIR}/${PN}-0.22-ruby-sharedlib.patch"
	"${FILESDIR}/${PN}-0.22-pc-libdir.patch"
)

src_prepare() {
	default_src_prepare
	sed -i \
		-e 's/-Os -ggdb//' \
		-e 's/^\(all:.*\) example/\1/' \
		-e 's/$(CC) -shared/$(CC) $(LDFLAGS) -shared/' \
		-e 's/ -o $@ $(LDLIBS) $^/ $^ $(LDLIBS) -o $@/' \
		-e 's/-lncursesw/-lncursesw -pthread/' \
		-e 's/\<ar\>/$(AR)/' \
		-e 's/\<ranlib\>/$(RANLIB)/' \
		Makefile || die "sed failed"

	if ! use static-libs ; then
		sed -i -e "/install .* libstfl.a/d" Makefile || die
	fi

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
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"

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
