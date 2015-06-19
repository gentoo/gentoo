# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mercury/mercury-11.07.1.ebuild,v 1.5 2012/06/25 12:22:53 keri Exp $

EAPI=2

inherit autotools elisp-common eutils flag-o-matic java-pkg-opt-2 multilib

PATCHSET_VER="4"
MY_P=${PN}-compiler-${PV}

DESCRIPTION="Mercury is a modern general-purpose logic/functional programming language"
HOMEPAGE="http://www.cs.mu.oz.au/research/mercury/index.html"
SRC_URI="http://www.mercury.csse.unimelb.edu.au/download/files/${MY_P}.tar.gz
	mirror://gentoo/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz
	test? ( http://www.mercury.csse.unimelb.edu.au/download/files/mercury-tests-${PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug emacs erlang examples java minimal readline test threads"

DEPEND="!dev-libs/mpatrol
	!dev-util/mono-debugger
	readline? ( sys-libs/readline )
	erlang? ( dev-lang/erlang )
	java? ( >=virtual/jdk-1.5 )"

RDEPEND="${DEPEND}
	emacs? ( virtual/emacs )"

S="${WORKDIR}"/${MY_P}
TESTDIR="${WORKDIR}"/${PN}-tests-${PV}

SITEFILE=50${PN}-gentoo.el

src_prepare() {
	cd "${WORKDIR}"
	EPATCH_FORCE=yes
	EPATCH_SUFFIX=patch
	epatch "${WORKDIR}"/${PV}

	sed -i -e "s/@libdir@/$(get_libdir)/" \
		"${S}"/scripts/Mmake.vars.in \
		|| die "sed libdir failed"

	if use test; then
		epatch "${WORKDIR}"/${PV}-tests
	fi

	cd "${S}"
	eautoconf
}

src_configure() {
	strip-flags

	local myconf
	myconf="--libdir=/usr/$(get_libdir) \
		--disable-gcc-back-end \
		--disable-deep-profiler \
		--disable-dotnet-grades \
		$(use_enable erlang erlang-grade) \
		$(use_enable java java-grade) \
		$(use_enable debug debug-grades) \
		$(use_enable threads par-grades) \
		$(use_enable !minimal most-grades) \
		$(use_with readline)"

	econf ${myconf}
}

src_compile() {
	# Generate Mercury .m dependencies. This step will vacuously
	# succeed if we do not have a bootstrappable instance of mmc
	# already installed. This step is required as mmc does not wait
	# for all dependencies to be generated before compiling .m files.
	emake \
		PARALLEL=${MAKEOPTS} \
		bootstrap_depend || die "emake depend failed"

	# Build Mercury using base llds grade
	emake \
		PARALLEL=${MAKEOPTS} \
		EXTRA_MLFLAGS=--no-strip \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		EXTRA_LD_LIBFLAGS="${LDFLAGS}" \
		|| die "emake failed"

	# We can now patch .m Mercury compiler files since we
	# have just built mercury_compiler.
	EPATCH_FORCE=yes
	EPATCH_SUFFIX=patch
	epatch "${WORKDIR}"/${PV}-mmc

	sed -i -e "s/@libdir@/$(get_libdir)/" \
		"${S}"/compiler/file_util.m \
		"${S}"/compiler/make.program_target.m \
		|| die "sed libdir failed"

	# Rebuild Mercury compiler using the just built mercury_compiler
	emake \
		PARALLEL=${MAKEOPTS} \
		EXTRA_MLFLAGS=--no-strip \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		EXTRA_LD_LIBFLAGS="${LDFLAGS}" \
		MERCURY_COMPILER="${S}"/compiler/mercury_compile \
		compiler || die "emake compiler failed"

	# The default Mercury grade may not be the same as the grade used to
	# compile the llds base grade. Since src_test() is run before
	# src_install() we compile the default grade now
	emake \
		PARALLEL=${MAKEOPTS} \
		EXTRA_MLFLAGS=--no-strip \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		EXTRA_LD_LIBFLAGS="${LDFLAGS}" \
		MERCURY_COMPILER="${S}"/compiler/mercury_compile \
		default_grade || die "emake default_grade failed"
}

src_test() {
	TEST_GRADE=`scripts/ml --print-grade`
	if [ -d "${S}"/install_grade_dir.${TEST_GRADE} ] ; then
		TWS="${S}"/install_grade_dir.${TEST_GRADE}
		cp browser/mer_browser.init "${TWS}"/browser/
		cp mdbcomp/mer_mdbcomp.init "${TWS}"/mdbcomp/
		cp runtime/mer_rt.init "${TWS}"/runtime/
		cp ssdb/mer_ssdb.init "${TWS}"/ssdb/
	else
		TWS="${S}"
	fi

	cd "${TESTDIR}"
	sed -i -e "s:@WORKSPACE@:${TWS}:" WS_FLAGS.ws \
		|| die "sed WORKSPACE failed"

	# Mercury tests must be run in C locale since Mercury output is
	# compared to hard-coded warnings/errors
	LC_ALL="C" \
	PATH="${TWS}"/scripts:"${TWS}"/util:"${TWS}"/slice:"${PATH}" \
	TERM="" \
	WORKSPACE="${TWS}" \
	MERCURY_COMPILER="${TWS}"/compiler/mercury_compile \
	MERCURY_CONFIG_DIR="${TWS}" \
	MMAKE_DIR="${TWS}"/scripts \
	MERCURY_SUPPRESS_STACK_TRACE=yes \
	GRADE=${TEST_GRADE} \
	MERCURY_ALL_LOCAL_C_INCL_DIRS=" -I${TWS}/boehm_gc \
					-I${TWS}/boehm_gc/include \
					-I${TWS}/runtime \
					-I${TWS}/library \
					-I${TWS}/mdbcomp \
					-I${TWS}/browser \
					-I${TWS}/trace" \
		mmake || die "mmake test failed"
}

src_install() {
	emake \
		PARALLEL=${MAKEOPTS} \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		EXTRA_LD_LIBFLAGS="${LDFLAGS}" \
		MERCURY_COMPILER="${S}"/compiler/mercury_compile \
		INSTALL_PREFIX="${D}"/usr \
		INSTALL_MAN_DIR="${D}"/usr/share/man \
		INSTALL_INFO_DIR="${D}"/usr/share/info \
		INSTALL_HTML_DIR="${D}"/usr/share/doc/${PF}/html \
		INSTALL_ELISP_DIR="${D}/${SITELISP}"/${PN} \
		install || die "make install failed"

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
			|| die "elisp-site-file-install failed"
	fi

	dodoc \
		BUGS HISTORY LIMITATIONS NEWS README README.Linux \
		README.Linux-Alpha README.Linux-m68k README.Linux-PPC \
		RELEASE_NOTES TODO VERSION WORK_IN_PROGRESS || die

	if use erlang; then
		dodoc README.Erlang || die
	fi

	if use java; then
		dodoc README.Java || die
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/samples
		doins samples/{*.m,README,Mmakefile} || die
		doins -r samples/c_interface \
			samples/diff \
			samples/muz \
			samples/rot13 \
			samples/solutions \
			samples/solver_types || die

		if use java; then
			doins -r samples/java_interface || die
		fi

		rm -rf $(find "${D}"/usr/share/doc/${PF}/samples \
				-name CVS -o -name .cvsignore)
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
