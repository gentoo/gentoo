# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_6 )

inherit autotools eutils gnome2 java-pkg-opt-2 python-r1

DESCRIPTION="A Syntactic English parser"
HOMEPAGE="https://www.abisource.com/projects/link-grammar/ https://www.link.cs.cmu.edu/link/"
SRC_URI="https://www.abisource.com/downloads/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="aspell +hunspell java python static-libs threads" # pcre
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
		dev-java/ant-core )
	python? ( ${PYTHON_DEPS} )
	!sci-mathematics/minisat
"
DEPEND="${RDEPEND}
	dev-lang/swig:0
	sys-devel/autoconf-archive
	virtual/pkgconfig
"

NORMAL_BUILD_DIR="${WORKDIR}/${P}-normal"

pkg_setup() {
	if use aspell && use hunspell; then
		ewarn "You have enabled 'aspell' and 'hunspell' support, but both cannot coexist,"
		ewarn "only hunspell will be built. Press Ctrl+C and set only 'aspell' USE flag if"
		ewarn "you want aspell support."
	fi
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	use java && java-pkg-opt-2_src_prepare

	# http://bugzilla.abisource.com/show_bug.cgi?id=13806
	eapply "${FILESDIR}"/${PN}-5.3.9-out-of-source-build.patch
	eapply_user
	eautoreconf

	if use python ; then
		prepare_python() {
			mkdir -p "${BUILD_DIR}" || die
		}
		python_foreach_impl prepare_python
	fi

	mkdir -p "${NORMAL_BUILD_DIR}" || die
	gnome2_src_prepare
}

src_configure() {
	local myconf=(
		--disable-editline
		--disable-perl-bindings
		--enable-shared
		--enable-sat-solver=bundled
		$(use_enable aspell)
		$(use_enable hunspell)
		$(usex hunspell --with-hunspell-dictdir=/usr/share/myspell)
		$(use_enable java java-bindings)
		# $(use_enable pcre regex-tokenizer)
		# $(use_with pcre)
		$(use_enable static-libs static)
		$(use_enable threads pthreads)
	)

	cd "${NORMAL_BUILD_DIR}" || die
	ECONF_SOURCE="${S}" gnome2_src_configure \
		--disable-python-bindings \
		--disable-python3-bindings \
		${myconf[@]}

	if use python ; then
		prepare_python() {
			if python_is_python3; then
				ECONF_SOURCE="${S}" gnome2_src_configure \
					--disable-python-bindings \
					--enable-python3-bindings \
					${myconf[@]}
			else
				ECONF_SOURCE="${S}" gnome2_src_configure \
					--enable-python-bindings \
					--disable-python3-bindings \
					${myconf[@]}
			fi
		}
		python_foreach_impl run_in_build_dir prepare_python
	fi
}

src_compile() {
	cd "${NORMAL_BUILD_DIR}" || die
	gnome2_src_compile

	if use python ; then
		compile_binding() {
			local pysuffix
			if python_is_python3; then
				pysuffix=3
			else
				pysuffix=
			fi

			emake -C bindings/python$pysuffix \
				VPATH="${S}:${NORMAL_BUILD_DIR}" \
				_clinkgrammar_la_DEPENDENCIES="${NORMAL_BUILD_DIR}"/link-grammar/liblink-grammar.la \
				_clinkgrammar_la_LIBADD="${NORMAL_BUILD_DIR}"/link-grammar/liblink-grammar.la
		}
		python_foreach_impl run_in_build_dir compile_binding
	fi
}

src_test() {
	cd "${NORMAL_BUILD_DIR}" || die
	ln -s "${S}"/data tests/data || die
	emake check
}

src_install() {
	cd "${NORMAL_BUILD_DIR}" || die
	gnome2_src_install

	if use python ; then
		install_binding() {
			local pysuffix
			if python_is_python3; then
				pysuffix=3
			else
				pysuffix=
			fi

			emake -C bindings/python$pysuffix \
				VPATH="${S}:${NORMAL_BUILD_DIR}" \
				_clinkgrammar_la_DEPENDENCIES="${NORMAL_BUILD_DIR}"/link-grammar/liblink-grammar.la \
				_clinkgrammar_la_LIBADD="${NORMAL_BUILD_DIR}"/link-grammar/liblink-grammar.la \
				DESTDIR="${D}" \
				install
		}
		python_foreach_impl run_in_build_dir install_binding
	fi
}

pkg_preinst() {
	use java && java-pkg-opt-2_pkg_preinst
	gnome2_pkg_preinst
}
