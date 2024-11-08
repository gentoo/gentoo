# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit autotools python-r1 out-of-source

DESCRIPTION="A Syntactic English parser"
HOMEPAGE="https://www.abisource.com/projects/link-grammar/ https://www.link.cs.cmu.edu/link/"
SRC_URI="https://www.gnucash.org/link-grammar/downloads/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/5"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~riscv sparc ~x86"
IUSE="aspell +hunspell python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# XXX: sqlite is automagic
# Does not build with >=sci-mathematics/minisat-2, bug #593662
RDEPEND="
	dev-db/sqlite:3
	dev-libs/libpcre2:=
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swig:0
	dev-build/autoconf-archive
	sys-devel/flex
	virtual/pkgconfig"

QA_CONFIG_IMPL_DECL_SKIP=(
	# _AC_UNDECLARED_BUILTIN false positive
	strchr
	typeof
)

pkg_setup() {
	if use aspell && use hunspell; then
		ewarn "You have enabled 'aspell' and 'hunspell' support, but both cannot coexist,"
		ewarn "only hunspell will be built. Press Ctrl+C and set only 'aspell' USE flag if"
		ewarn "you want aspell support."
	fi
}

src_prepare() {
	default
	eautoreconf
}

my_src_configure() {
	local myconf=(
		--disable-maintainer-mode
		--disable-editline
		# java is hopelessly broken, invokes maven at build time (bug #806157)
		--disable-java-bindings
		--disable-perl-bindings
		--disable-sat-solver
		--with-regexlib=pcre2
		$(use_enable aspell)
		$(use_enable hunspell)
		$(usev hunspell --with-hunspell-dictdir="${EPREFIX}"/usr/share/myspell)
		# requires flex, since reflex support is flaky, #890158
		LEX="flex"
	)

	econf \
		--disable-python-bindings \
		"${myconf[@]}"

	if use python; then
		python_configure() {
			econf \
				--enable-python-bindings \
				"${myconf[@]}"
		}
		python_foreach_impl run_in_build_dir python_configure
	fi
}

my_src_compile() {
	local -x MAIN_BUILD_DIR="${BUILD_DIR}"
	default

	if use python; then
		python_compile() {
			emake -C bindings/python \
				VPATH="${S}:${MAIN_BUILD_DIR}" \
				_clinkgrammar_la_DEPENDENCIES="${MAIN_BUILD_DIR}"/link-grammar/liblink-grammar.la \
				_clinkgrammar_la_LIBADD="${MAIN_BUILD_DIR}"/link-grammar/liblink-grammar.la
		}
		python_foreach_impl run_in_build_dir python_compile
	fi
}

my_src_install() {
	local -x MAIN_BUILD_DIR="${BUILD_DIR}"
	default

	if use python; then
		python_install() {
			emake -C bindings/python \
				VPATH="${S}:${MAIN_BUILD_DIR}" \
				_clinkgrammar_la_DEPENDENCIES="${MAIN_BUILD_DIR}"/link-grammar/liblink-grammar.la \
				_clinkgrammar_la_LIBADD="${MAIN_BUILD_DIR}"/link-grammar/liblink-grammar.la \
				DESTDIR="${D}" \
				install
		}
		python_foreach_impl run_in_build_dir python_install
	fi

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
