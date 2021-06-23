# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit autotools java-pkg-opt-2 python-r1 out-of-source

DESCRIPTION="A Syntactic English parser"
HOMEPAGE="https://www.abisource.com/projects/link-grammar/ https://www.link.cs.cmu.edu/link/"
SRC_URI="https://www.abisource.com/downloads/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="aspell +hunspell java python" # pcre
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# XXX: sqlite is automagic
# Does not build with >=sci-mathematics/minisat-2, bug #593662
# add pcre support: pcre? ( dev-libs/libpcre )
RDEPEND="
	dev-db/sqlite:3
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell )
	java? (
		>=virtual/jdk-1.6:*
		dev-java/ant-core
	)
	python? ( ${PYTHON_DEPS} )
	!sci-mathematics/minisat"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swig:0
	sys-devel/autoconf-archive
	virtual/pkgconfig"

pkg_setup() {
	if use aspell && use hunspell; then
		ewarn "You have enabled 'aspell' and 'hunspell' support, but both cannot coexist,"
		ewarn "only hunspell will be built. Press Ctrl+C and set only 'aspell' USE flag if"
		ewarn "you want aspell support."
	fi
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	default
	use java && java-pkg-opt-2_src_prepare

	eapply "${FILESDIR}"/${PN}-5.8.1-lld.patch

	eautoreconf
}

my_src_configure() {
	local myconf=(
		--disable-maintainer-mode
		--disable-editline
		--disable-perl-bindings
		--disable-static
		--enable-sat-solver=bundled
		$(use_enable aspell)
		$(use_enable hunspell)
		$(usex hunspell --with-hunspell-dictdir="${EPREFIX}"/usr/share/myspell '')
		$(use_enable java java-bindings)
		# $(use_enable pcre regex-tokenizer)
		# $(use_with pcre)
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

pkg_preinst() {
	use java && java-pkg-opt-2_pkg_preinst
}
