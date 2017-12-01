# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools elisp-common eutils flag-o-matic multilib python-single-r1 toolchain-funcs

# To stop the download madness we now roll our own tarball (Feb 2016)
DESCRIPTION="Research tool for commutative algebra and algebraic geometry"
HOMEPAGE="http://www.math.uiuc.edu/Macaulay2/"
BASE_URI="http://www.math.uiuc.edu/Macaulay2/Downloads/OtherSourceCode/"
BASE_URI2="https://dev.gentoo.org/~tomka/files/"
SRC_URI="
	${BASE_URI2}/${P}-fat.tar.bz2
"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug emacs +optimization"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	sys-process/time
	virtual/pkgconfig"

RDEPEND="${PYTHON_DEPS}
	sys-libs/gdbm
	sci-mathematics/pari[gmp]
	>=sys-libs/readline-6.1
	dev-libs/libxml2:2
	sci-mathematics/flint[gc]
	sci-mathematics/frobby
	sci-mathematics/4ti2
	sci-mathematics/nauty
	>=sci-mathematics/normaliz-2.8
	sci-mathematics/gfan
	sci-libs/cdd+
	sci-libs/cddlib
	sci-libs/lrslib[gmp]
	virtual/blas
	virtual/lapack
	dev-util/ctags
	sys-libs/ncurses
	>=dev-libs/boehm-gc-7.4[threads]
	dev-libs/libatomic_ops
	emacs? ( virtual/emacs )"

SITEFILE=70Macaulay2-gentoo.el

S="${WORKDIR}/M2/M2"

pkg_setup () {
	tc-export CC CPP CXX PKG_CONFIG
	append-cppflags "-I/usr/include/frobby"
	# gtest needs python:2
	python-single-r1_pkg_setup
}

src_prepare() {
	# Patching .m2 files to look for external programs in
	# /usr/bin
	epatch "${FILESDIR}"/1.6-paths-of-external-programs.patch

	# Shortcircuit lapack tests
	epatch "${FILESDIR}/${P}"-lapack.patch

	eautoreconf
}

src_configure (){
	# Recommended in bug #268064 Possibly unecessary
	# but should not hurt anybody.
	if ! use emacs; then
		tags="ctags"
	fi

	# configure instead of econf to enable install with --prefix
	./configure LIBS="$($(tc-getPKG_CONFIG) --libs lapack)" \
		--prefix="${D}usr/" \
		--libdir='${exec_prefix}'/$(get_libdir)/ \
		--disable-encap \
		--disable-strip \
		--with-issue=Gentoo \
		$(use_enable optimization optimize) \
		$(use_enable debug) \
		--enable-build-libraries="factory" \
		--with-unbuilt-programs="4ti2 gfan normaliz nauty cddplus lrslib" \
		|| die "failed to configure Macaulay"
}

src_compile() {
	# Parallel build not supported yet
	emake IgnoreExampleErrors=true -j1

	if use emacs; then
		cd "${S}/Macaulay2/emacs" || die
		elisp-compile *.el
	fi
}

src_test() {
	# No parallel tests yet & Need to increase the time
	# limit for long running tests in Schubert2 to pass
	emake TLIMIT=750 -j1 check
}

src_install () {
	# Parallel install not supported yet
	emake IgnoreExampleErrors=true -j1 install

	# Remove emacs files and install them in the
	# correct place if use emacs
	rm -rf "${ED}"/usr/share/emacs/site-lisp || die
	if use emacs; then
		cd "${S}/Macaulay2/emacs" || die
		elisp-install ${PN} *.elc *.el
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		elog "If you want to set a hot key for Macaulay2 in Emacs add a line similar to"
		elog "(global-set-key [ f12 ] 'M2)"
		elog "in order to set it to F12 (or choose a different one)."
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
