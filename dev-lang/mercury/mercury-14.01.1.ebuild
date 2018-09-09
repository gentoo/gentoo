# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools elisp-common eutils flag-o-matic java-pkg-opt-2 multilib xdg-utils

PATCHSET_VER="3"
MY_P=${PN}-srcdist-${PV}

DESCRIPTION="Mercury is a modern general-purpose logic/functional programming language"
HOMEPAGE="http://www.mercurylang.org/index.html"
SRC_URI="http://dl.mercurylang.org/release/${MY_P}.tar.gz
	mirror://gentoo/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="debug emacs erlang examples java mono profile readline threads trail"

DEPEND="!dev-libs/mpatrol
	!dev-util/mono-debugger
	net-libs/libnsl:0=
	readline? ( sys-libs/readline:= )
	erlang? ( dev-lang/erlang )
	java? ( >=virtual/jdk-1.6:= )
	mono? ( dev-lang/mono )"

RDEPEND="${DEPEND}
	emacs? ( virtual/emacs )"

S="${WORKDIR}"/${MY_P}

SITEFILE=50${PN}-gentoo.el

src_prepare() {
	cd "${WORKDIR}" || die
	EPATCH_FORCE=yes
	EPATCH_SUFFIX=patch
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		epatch "${WORKDIR}"/${PV}
	fi

	sed -i -e "s/@libdir@/$(get_libdir)/" \
		"${S}"/scripts/Mmake.vars.in \
		|| die "sed libdir failed"

	cd "${S}" || die
	eautoconf

	xdg_environment_reset
}

src_configure() {
	strip-flags

	local myconf
	myconf="--libdir=/usr/$(get_libdir) \
		$(use_enable mono csharp-grade) \
		$(use_enable erlang erlang-grade) \
		$(use_enable java java-grade) \
		$(use_enable debug debug-grades) \
		$(use_enable profile prof-grades) \
		$(use_enable threads par-grades) \
		$(use_enable trail trail-grades) \
		$(use_with readline)"

	econf ${myconf}
}

src_compile() {
	# Prepare mmake flags
	echo "EXTRA_CFLAGS  = ${CFLAGS}"  >> Mmake.params
	echo "EXTRA_LDFLAGS = ${LDFLAGS}" >> Mmake.params
	echo "EXTRA_MLFLAGS = --no-strip" >> Mmake.params

	if use x86; then
		echo "CFLAGS-ml_backend.ml_closure_gen = -O0" >> Mmake.params
		echo "CFLAGS-ml_backend.ml_unify_gen = -O0" >> Mmake.params
		echo "CFLAGS-ml_backend.rtti_to_mlds = -O0" >> Mmake.params
		echo "CFLAGS-display_report = -O0" >> Mmake.params
		echo "CFLAGS-mercury_ho_call = -O0" >> Mmake.params
		echo "CFLAGS-mercury_trace_vars = -O0" >> Mmake.params
	fi

	# Build Mercury using bootstrap grade
	emake \
		PARALLEL="'${MAKEOPTS}'" \
		|| die "emake failed"

	# We can now patch .m Mercury compiler files since we
	# have just built mercury_compiler.
	EPATCH_FORCE=yes
	EPATCH_SUFFIX=patch
	if [[ -d "${WORKDIR}"/${PV}-mmc ]] ; then
		epatch "${WORKDIR}"/${PV}-mmc
	fi

	sed -i -e "s/@libdir@/$(get_libdir)/" \
		"${S}"/compiler/file_util.m \
		"${S}"/compiler/make.program_target.m \
		|| die "sed libdir failed"

	# Rebuild Mercury compiler using the just built mercury_compiler
	emake \
		PARALLEL="'${MAKEOPTS}'" \
		MERCURY_COMPILER="${S}"/compiler/mercury_compile \
		compiler || die "emake compiler failed"

	# The default Mercury grade may not be the same as the bootstrap
	# grade. Since src_test() is run before src_install() we compile
	# the default grade now
	emake \
		PARALLEL="'${MAKEOPTS}'" \
		MERCURY_COMPILER="${S}"/compiler/mercury_compile \
		default_grade || die "emake default_grade failed"
}

src_test() {
	TEST_GRADE=$(scripts/ml --print-grade)
	if [ -d "${S}"/install_grade_dir.${TEST_GRADE} ] ; then
		TWS="${S}"/install_grade_dir.${TEST_GRADE}
		cp runtime/mer_rt.init "${TWS}"/runtime/
		cp mdbcomp/mer_mdbcomp.init "${TWS}"/mdbcomp/
		cp browser/mer_browser.init "${TWS}"/browser/
	else
		TWS="${S}"
	fi

	cd "${S}"/tests || die
	sed -e "s:@WORKSPACE@:${TWS}:" \
		< WS_FLAGS.ws \
		> WS_FLAGS \
		|| die "sed WORKSPACE failed"
	sed -e "s:@WORKSPACE@:${TWS}:" \
		< .mgnuc_copts.ws \
		> .mgnuc_copts \
		|| die "sed WORKSPACE failed"
	find . -mindepth 1 -type d -exec cp .mgnuc_opts  {} \;
	find . -mindepth 1 -type d -exec cp .mgnuc_copts {} \;

	# Mercury tests must be run in C locale since Mercury output is
	# compared to hard-coded warnings/errors
	LC_ALL="C" \
	PATH="${TWS}"/scripts:"${TWS}"/util:"${S}"/slice:"${PATH}" \
	TERM="" \
	WORKSPACE="${TWS}" \
	WORKSPACE_FLAGS=yes \
	MERCURY_COMPILER="${TWS}"/compiler/mercury_compile \
	MMAKE_DIR="${TWS}"/scripts \
	MERCURY_SUPPRESS_STACK_TRACE=yes \
	GRADE=${TEST_GRADE} \
		mmake || die "mmake test failed"
}

src_install() {
	emake \
		PARALLEL="'${MAKEOPTS}'" \
		MERCURY_COMPILER="${S}"/compiler/mercury_compile \
		DESTDIR="${D}" \
		INSTALL_PREFIX="${D}"/usr \
		INSTALL_MAN_DIR="${D}"/usr/share/man \
		INSTALL_INFO_DIR="${D}"/usr/share/info \
		INSTALL_HTML_DIR="${D}"/usr/share/doc/${PF}/html \
		INSTALL_ELISP_DIR="${D}/${SITELISP}"/${PN} \
		install || die "emake install failed"

	if use java; then
		keepdir /usr/$(get_libdir)/mercury/modules/java
	fi

	if use mono; then
		keepdir /usr/$(get_libdir)/mercury/modules/csharp
	fi

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

		ecvs_clean "${D}"/usr/share/doc/${PF}/samples
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
